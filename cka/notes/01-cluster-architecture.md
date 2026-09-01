# 01. Cluster Architecture, Installation & Configuration (25%)

## 커리큘럼 항목

- RBAC 관리
- Kubernetes 설치용 인프라 준비
- kubeadm으로 클러스터 생성/관리
- 클러스터 라이프사이클(업그레이드, 백업)
- HA 컨트롤플레인
- Helm, Kustomize
- 확장 인터페이스: CNI, CSI, CRI
- CRD, Operator

---

## 1. 컨트롤플레인 구조

| 컴포넌트 | 역할 | 위치 |
|---|---|---|
| kube-apiserver | 모든 요청 진입점, 인증/인가/어드미션 | static pod, `/etc/kubernetes/manifests/kube-apiserver.yaml` |
| etcd | 클러스터 상태 저장(KV), 2379(client)/2380(peer) | static pod, 데이터 `/var/lib/etcd` |
| kube-scheduler | Pod → Node 배치 결정 | static pod |
| kube-controller-manager | Deployment/RS/Node 등 컨트롤러 루프 | static pod |
| kubelet | 노드 에이전트, Pod 실행, static pod 감시 | systemd 서비스 |
| kube-proxy | Service → iptables/ipvs 규칙 | DaemonSet |
| CoreDNS | 클러스터 DNS | Deployment |
| CNI plugin | Pod 네트워크 | DaemonSet (calico/flannel/cilium) |

시험 포인트: static pod 매니페스트 경로는 kubelet 설정 `/var/lib/kubelet/config.yaml` 의 `staticPodPath`. 매니페스트를 고치면 kubelet이 자동 재생성. 컨트롤플레인 Pod가 안 뜨면 `crictl ps -a`, `crictl logs`, `/var/log/pods/` 확인.

## 2. RBAC

4가지 오브젙트:

| 오브젝트 | 범위 | 용도 |
|---|---|---|
| Role | namespace | 권한 정의 |
| ClusterRole | cluster | 권한 정의 (nodes, pv, 비네임스페이스 리소스, 또는 전 ns 공통) |
| RoleBinding | namespace | Role 또는 ClusterRole을 ns 내 주체에 부여 |
| ClusterRoleBinding | cluster | ClusterRole을 전체에 부여 |

주체(subject): `User`, `Group`, `ServiceAccount`.

```bash
k create role dev --verb=get,list,create,delete --resource=pods,deployments -n dev
k create rolebinding dev-rb --role=dev --user=jane -n dev
k create clusterrole cr --verb=get,list,watch --resource=nodes,persistentvolumes
k create clusterrolebinding crb --clusterrole=cr --serviceaccount=monitoring:prom-sa
k auth can-i list nodes --as=jane
k auth can-i get pods --as=system:serviceaccount:dev:app-sa -n dev
```

- 하위 리소스: `--resource=pods/log`, `pods/exec`, `deployments/scale`.
- API 그룹: `deployments` → `apps`, `roles` → `rbac.authorization.k8s.io`. `k api-resources` 로 확인.
- ClusterRole + RoleBinding = ClusterRole 권한을 특정 ns에만 부여(재사용 패턴).
- verbs: get, list, watch, create, update, patch, delete, deletecollection. `*` 전체.
- Pod에 SA 지정: `spec.serviceAccountName`. 토큰 자동 마운트 끄기 `automountServiceAccountToken: false`.
- 인증서 기반 User 생성: CSR 리소스 → `k certificate approve` → 클라이언트 cert. 문제로 나오면 문서 "Certificate Signing Requests" 참고.

## 3. kubeadm 클러스터 생성

사전 준비(인프라):
- swap off, 컨테이너 런타임(containerd) 설치, `br_netfilter`, `net.ipv4.ip_forward=1`
- kubeadm, kubelet, kubectl 동일 버전. apt hold.
- 포트: 6443(apiserver), 2379-2380(etcd), 10250(kubelet), 10257(ccm), 10259(sched), 30000-32767(NodePort)

```bash
# control-plane
kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=<ip>
mkdir -p $HOME/.kube && cp /etc/kubernetes/admin.conf $HOME/.kube/config
kubectl apply -f <cni.yaml>

# worker
kubeadm token create --print-join-command      # control-plane에서
kubeadm join <ip>:6443 --token ... --discovery-token-ca-cert-hash sha256:...
```

토큰 만료 24h. `kubeadm token list`.

## 4. 클러스터 업그레이드 (kubeadm)

순서: **control-plane 먼저 → worker 하나씩**. 마이너 버전 1단계씩만(1.34 → 1.35).

```bash
# 1) control-plane
kubectl drain cp01 --ignore-daemonsets
apt-mark unhold kubeadm && apt-get update && apt-get install -y kubeadm='1.35.x-*' && apt-mark hold kubeadm
kubeadm version
kubeadm upgrade plan
kubeadm upgrade apply v1.35.x
apt-mark unhold kubelet kubectl && apt-get install -y kubelet='1.35.x-*' kubectl='1.35.x-*' && apt-mark hold kubelet kubectl
systemctl daemon-reload && systemctl restart kubelet
kubectl uncordon cp01

# 2) worker (각 노드)
kubectl drain node01 --ignore-daemonsets --delete-emptydir-data --force
ssh node01
  apt-mark unhold kubeadm && apt-get install -y kubeadm='1.35.x-*' && apt-mark hold kubeadm
  kubeadm upgrade node
  apt-mark unhold kubelet kubectl && apt-get install -y kubelet='1.35.x-*' kubectl='1.35.x-*' && apt-mark hold kubelet kubectl
  systemctl daemon-reload && systemctl restart kubelet
exit
kubectl uncordon node01
```

- 1.28+ apt repo는 마이너 버전별 분리: `/etc/apt/sources.list.d/kubernetes.list` 의 `v1.34` → `v1.35` 로 바꾸고 `apt update` 먼저.
- 다수 control-plane: 첫 번째만 `upgrade apply`, 나머지는 `upgrade node`.
- 시험에서는 "control-plane 노드만 업그레이드", 또는 "worker만" 처럼 범위 지정. 문제 범위 넘게 하지 말 것.

## 5. etcd 백업 / 복원

etcd static pod 매니페스트에서 인증서 경로 확인: `cat /etc/kubernetes/manifests/etcd.yaml | grep -E "cert|key|listen-client"`.

```bash
# 백업
ETCDCTL_API=3 etcdctl snapshot save /opt/etcd-backup.db \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key
etcdctl snapshot status /opt/etcd-backup.db -w table   # (etcdutl snapshot status 권장)

# 복원
ETCDCTL_API=3 etcdctl snapshot restore /opt/etcd-backup.db --data-dir=/var/lib/etcd-restore
# (신버전: etcdutl snapshot restore ... --data-dir ...)
# etcd.yaml 의 hostPath 볼륨 경로를 새 data-dir로 교체
vim /etc/kubernetes/manifests/etcd.yaml   # volumes: hostPath path: /var/lib/etcd -> /var/lib/etcd-restore
# kubelet이 etcd 재시작. 1~2분 대기. 필요시 다른 컨트롤플레인 static pod 도 재시작됨.
```

- etcdctl 없으면: `k -n kube-system exec etcd-<node> -- etcdctl ...` 또는 노드에 설치된 `etcdutl`.
- 외부 etcd(별도 서버)면 `--endpoints` 가 다르고, systemd 유닛 `etcd.service` 의 `--data-dir` 을 변경 후 `systemctl restart etcd`.
- 복원 시 `--data-dir` 가 이미 존재하면 실패. 새 경로 사용.

## 6. 인증서

```bash
kubeadm certs check-expiration
kubeadm certs renew all           # 이후 컨트롤플레인 static pod 재시작
openssl x509 -in /etc/kubernetes/pki/apiserver.crt -noout -text | grep -A2 Validity
```

경로: `/etc/kubernetes/pki/` (ca, apiserver, apiserver-kubelet-client, front-proxy, etcd/*). kubeconfig: `/etc/kubernetes/{admin,kubelet,controller-manager,scheduler}.conf`.

## 7. HA 컨트롤플레인

- Stacked etcd: 각 control-plane에 etcd 동거. 최소 3대(쿼럼 = N/2+1).
- External etcd: 별도 etcd 클러스터.
- 앞단 로드밸런서(`--control-plane-endpoint=lb:6443`) 필수. `kubeadm init --upload-certs` 후 `kubeadm join --control-plane --certificate-key`.
- 시험은 개념 + join 명령 수준. 실습 문제로 여러 대 세팅은 안 나옴.

## 8. Helm

```bash
helm repo add <name> <url>; helm repo update
helm search repo <kw> --versions
helm install <release> <repo/chart> -n <ns> --create-namespace --version X --set k=v -f values.yaml
helm upgrade <release> <repo/chart> --version Y
helm rollback <release> <rev>
helm list -A; helm history <release>; helm status <release>
helm uninstall <release> -n <ns>
helm show values <repo/chart>
helm template <release> <chart> -f values.yaml     # 렌더링만
helm pull <repo/chart> --untar
```

시험 유형: "특정 차트 특정 버전 설치", "릴리스 업그레이드/롤백", "values 수정해서 재배포", "차트 template 렌더링 결과를 파일로 저장".

## 9. Kustomize

```
base/
  kustomization.yaml   # resources: [deploy.yaml, svc.yaml]
  deploy.yaml
overlays/prod/
  kustomization.yaml   # resources: [../../base], namePrefix, namespace, patches, images, replicas, configMapGenerator
```

```yaml
# overlays/prod/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
namespace: prod
namePrefix: prod-
resources:
  - ../../base
images:
  - name: nginx
    newTag: "1.25"
replicas:
  - name: web
    count: 5
patches:
  - path: patch.yaml
configMapGenerator:
  - name: app-cfg
    literals: [LOG_LEVEL=debug]
```

```bash
k kustomize overlays/prod        # 결과 보기
k apply -k overlays/prod
k delete -k overlays/prod
```

## 10. 확장 인터페이스

| 인터페이스 | 대상 | 확인 |
|---|---|---|
| CRI | 컨테이너 런타임(containerd, CRI-O) | `crictl info`, kubelet `--container-runtime-endpoint`, `/etc/containerd/config.toml` |
| CNI | Pod 네트워크(Calico, Flannel, Cilium) | `/etc/cni/net.d/*.conf`, `/opt/cni/bin/`, CNI DaemonSet |
| CSI | 스토리지 드라이버 | `k get csidrivers`, `k get csinodes`, StorageClass `provisioner` |

CNI 문제 유형: "CNI 설치되지 않아 노드 NotReady, Pod ContainerCreating" → 문서에서 매니페스트 URL 찾아 apply. 또는 `/etc/cni/net.d` 비어있는지 확인.

## 11. CRD / Operator

```bash
k get crd
k get crd <name> -o yaml | less        # spec.versions[].schema, scope, names
k api-resources | grep <group>
k explain <crd-kind>.spec
k get <crd-kind> -A
```

- CRD = 새 리소스 타입 정의. CR = 그 인스턴스. Operator = CR을 감시하는 컨트롤러(Deployment로 배포).
- 시험 유형: "설치된 CRD 목록 중 특정 그룹의 것 파일에 저장", "CR 생성", "CRD의 특정 필드 설명 `k explain`".
- CRD 만들기 문제는 문서 "Extend the Kubernetes API with CustomResourceDefinitions" 예제 복사.

## 12. 노드 관리

```bash
k drain node01 --ignore-daemonsets --delete-emptydir-data --force
k cordon node01 / k uncordon node01
k delete node node01
kubeadm reset            # 노드에서 클러스터 탈퇴
k get no -o wide         # 버전, OS, 런타임, IP
k describe no node01     # Conditions, Taints, Allocatable, Events
```

## 시험 빈출 정리

1. RBAC: SA + Role + RoleBinding 만들고 `k auth can-i`로 검증
2. etcd 백업 → 복원 (인증서 경로 실수 주의)
3. kubeadm 업그레이드 control-plane 또는 worker 1대
4. Helm 특정 차트/버전 설치 or 업그레이드
5. Kustomize overlay 적용
6. CRD 조회/생성
7. 노드 drain/cordon 후 작업
8. 인증서 만료 확인
