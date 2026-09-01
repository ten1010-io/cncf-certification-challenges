# Drills — Cluster Architecture, Installation & Configuration

준비: `kubectl create ns drill-c --dry-run=client -o yaml | kubectl apply -f -`
정리: `kubectl delete ns drill-c; kubectl delete clusterrole node-viewer; kubectl delete clusterrolebinding node-viewer-b`

---

### C1. ns `drill-c` 에 SA `reader`, Role `pod-reader`(pods get/list/watch, pods/log get), RoleBinding. `k auth can-i` 로 검증.
<details><summary>정답</summary>

```bash
k -n drill-c create sa reader
k -n drill-c create role pod-reader --verb=get,list,watch --resource=pods --verb=get --resource=pods/log
# 위처럼 verb/resource 혼합은 모두 적용됨 → 정확히 하려면 edit 로 rule 분리
k -n drill-c create rolebinding pod-reader-b --role=pod-reader --serviceaccount=drill-c:reader
k auth can-i list pods --as=system:serviceaccount:drill-c:reader -n drill-c      # yes
k auth can-i delete pods --as=system:serviceaccount:drill-c:reader -n drill-c    # no
```
</details>

### C2. User `jane` 이 모든 ns 의 nodes, namespaces 를 get/list 할 수 있게 ClusterRole `node-viewer` + ClusterRoleBinding.
<details><summary>정답</summary>

```bash
k create clusterrole node-viewer --verb=get,list --resource=nodes,namespaces
k create clusterrolebinding node-viewer-b --clusterrole=node-viewer --user=jane
k auth can-i list nodes --as=jane
```
</details>

### C3. ClusterRole `view`(내장) 를 SA `drill-c/reader` 에게 **drill-c 네임스페이스에서만** 부여.
<details><summary>정답</summary>

```bash
k -n drill-c create rolebinding reader-view --clusterrole=view --serviceaccount=drill-c:reader
```
ClusterRole + RoleBinding = ns 범위 한정.
</details>

### C4. etcd 스냅샷을 `/opt/drill.db` 에 저장하고 status 를 표로 출력. (노드에 etcdctl/etcdutl 설치됨)
<details><summary>정답</summary>

```bash
docker exec -it cka-control-plane bash
  grep -E "cert-file|key-file|trusted-ca" /etc/kubernetes/manifests/etcd.yaml
  ETCDCTL_API=3 etcdctl snapshot save /opt/drill.db \
    --endpoints=https://127.0.0.1:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt \
    --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key
  etcdutl snapshot status /opt/drill.db -w table
```
실제 시험(kubeadm)과 경로 동일. 노드에 etcdctl 없으면 `k -n kube-system exec etcd-cka-control-plane -- etcdctl ...` (저장 경로는 `/var/lib/etcd/` 아래만 가능).
</details>

### C5. etcd 복원 절차를 말로 4단계.
<details><summary>정답</summary>

1. `etcdctl snapshot restore <file> --data-dir=/var/lib/etcd-new`
2. `/etc/kubernetes/manifests/etcd.yaml` 의 hostPath `path:` 를 새 디렉토리로 변경
3. kubelet 이 etcd 재생성 대기(1~2분). `crictl ps` 로 확인
4. `k get po -A` 로 복원된 상태 확인. 필요시 kube-apiserver 등 다른 static pod 도 재시작(manifests 를 잠깐 옮기기)
</details>

### C6. worker `node01` 을 v1.35.0 으로 업그레이드하는 명령을 순서대로.
<details><summary>정답</summary>

```bash
kubectl drain node01 --ignore-daemonsets --delete-emptydir-data
ssh node01
  sed -i 's#v1.34#v1.35#' /etc/apt/sources.list.d/kubernetes.list && apt-get update
  apt-mark unhold kubeadm && apt-get install -y kubeadm='1.35.0-*' && apt-mark hold kubeadm
  kubeadm upgrade node
  apt-mark unhold kubelet kubectl && apt-get install -y kubelet='1.35.0-*' kubectl='1.35.0-*' && apt-mark hold kubelet kubectl
  systemctl daemon-reload && systemctl restart kubelet
  exit
kubectl uncordon node01
```
worker 는 `upgrade node`, control-plane 은 `upgrade apply`.
</details>

### C7. kubeadm 으로 새 worker 를 조인시키는 토큰과 명령을 만들어라.
<details><summary>정답</summary>

```bash
kubeadm token create --print-join-command
# 출력: kubeadm join <cp>:6443 --token ... --discovery-token-ca-cert-hash sha256:...
kubeadm token list
```
</details>

### C8. 클러스터 인증서 만료일 확인 + apiserver 인증서만 갱신.
<details><summary>정답</summary>

```bash
kubeadm certs check-expiration
kubeadm certs renew apiserver
# static pod 재시작 필요: manifests 이동 후 복귀 또는 crictl 로 컨테이너 종료
```
</details>

### C9. Helm: 로컬 tgz 차트 `/tmp/cka-exam-02/charts/webapp-0.1.0.tgz` 를 릴리스 `d-web` 으로 ns `drill-c` 에 설치, `service.type=NodePort`. 이후 0.2.0 으로 업그레이드, 다시 rev 1 로 롤백.
<details><summary>정답</summary>

```bash
helm install d-web /tmp/cka-exam-02/charts/webapp-0.1.0.tgz -n drill-c --set service.type=NodePort
helm upgrade d-web /tmp/cka-exam-02/charts/webapp-0.2.0.tgz -n drill-c --reuse-values
helm rollback d-web 1 -n drill-c
helm history d-web -n drill-c
```
(차트는 exam-02 setup 이 만듦. 없으면 `helm create webapp && helm package webapp`)
</details>

### C10. Kustomize overlay 로 base Deployment 의 replicas 5, ns `drill-c`, 라벨 `env=drill` 공통 추가.
<details><summary>정답</summary>

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
namespace: drill-c
resources: [../../base]
labels:
  - pairs: {env: drill}
    includeSelectors: true
replicas:
  - {name: web, count: 5}
```
`k apply -k overlays/drill`
</details>

### C11. 설치된 CRD 중 `gateway.networking.k8s.io` 그룹의 이름들을 파일로. `HTTPRoute` 의 `spec.rules.backendRefs` 필드 설명 출력.
<details><summary>정답</summary>

```bash
k get crd -o jsonpath='{range .items[?(@.spec.group=="gateway.networking.k8s.io")]}{.metadata.name}{"\n"}{end}'
k explain httproute.spec.rules.backendRefs
```
</details>

### C12. 노드의 CRI 런타임과 소켓, CNI 플러그인 설정 파일 위치 확인.
<details><summary>정답</summary>

```bash
k get no -o wide                                 # CONTAINER-RUNTIME
docker exec -it cka-control-plane bash
  crictl info | grep -i runtime
  grep container-runtime-endpoint /var/lib/kubelet/kubeadm-flags.env
  ls /etc/cni/net.d/ ; ls /opt/cni/bin/
```
</details>

### C13. `cka-worker` 를 drain 하고, 다시 스케줄 가능하게.
<details><summary>정답</summary>

```bash
k drain cka-worker --ignore-daemonsets --delete-emptydir-data --force
k get no
k uncordon cka-worker
```
</details>

### C14. 스케줄러가 죽은 상태에서 Pod 를 특정 노드에 띄우는 방법.
<details><summary>정답</summary>

`spec.nodeName: cka-worker` 직접 지정 → kubelet 이 스케줄러 없이 실행. 또는 static pod.
</details>
