# 05. Troubleshooting (30%)

## 커리큘럼 항목

- 클러스터/노드 트러블슈팅
- 컨트롤플레인 컴포넌트 트러블슈팅
- 클러스터·앱 리소스 사용량 모니터링
- 컨테이너 출력 스트림(로그) 관리
- 서비스·네트워크 트러블슈팅

비중 30%. 문제당 배점 높음. 앞 4개 도메인을 다 알아야 풀림.

---

## 1. 표준 진단 순서

```
1. k get no                          노드 Ready?
2. k get po -A | grep -v Running     비정상 Pod 어디?
3. k -n kube-system get po           컨트롤플레인/CNI/DNS/proxy 정상?
4. k describe <리소스>               Events 읽기 (가장 많은 힌트)
5. k logs <pod> [-c] [--previous]    앱 로그
6. k get events -A --sort-by=.lastTimestamp
7. 노드 ssh → systemctl / journalctl / crictl
```

## 2. Pod 상태별 원인

| 상태 | 원인 | 조치 |
|---|---|---|
| Pending | 스케줄 불가: 리소스 부족, taint, nodeSelector/affinity 불일치, PVC Pending, 스케줄러 죽음 | `k describe po` Events → 조건 수정. 스케줄러: `k -n kube-system get po` |
| ContainerCreating | 이미지 pull 중, 볼륨 마운트 실패(PVC/CM/Secret 없음), CNI 문제 | Events 확인. CM/Secret 이름, CNI Pod |
| ImagePullBackOff / ErrImagePull | 이미지 이름/태그 오타, private registry 인증 | `k set image`, imagePullSecrets |
| CrashLoopBackOff | 앱이 시작 후 종료: 잘못된 command/args, 설정 오류, liveness 실패, 의존 서비스 없음 | `k logs --previous`, command 확인, probe 확인 |
| Error / Completed | Job이면 정상(Completed). Pod면 command 종료 | restartPolicy 확인 |
| OOMKilled | 메모리 limit 초과 | `k describe po` Last State: OOMKilled → limit 증가 |
| Running but not Ready | readinessProbe 실패 | probe 경로/포트 확인 |
| Terminating 멈춤 | finalizer, 노드 다운 | `k delete po X --force --grace-period=0` |
| CreateContainerConfigError | CM/Secret 키 없음 | env valueFrom 이름 확인 |
| Init:0/1, Init:CrashLoopBackOff | init container 실패 | `k logs X -c <init>` |
| Evicted | 노드 디스크/메모리 압박 | `k describe no` Conditions |

```bash
k get po X -o jsonpath='{.status.containerStatuses[*].state}'
k get po X -o yaml | grep -A5 lastState
k logs X --previous
k describe po X | sed -n '/Events/,$p'
```

## 3. 노드 NotReady

```bash
k describe no node01          # Conditions: Ready=False/Unknown, 이유. Taints: not-ready/unreachable
ssh node01
systemctl status kubelet
journalctl -u kubelet -n 100 --no-pager | grep -iE "error|fail"
```

흔한 원인과 수정:

| 원인 | 증상(journalctl) | 수정 |
|---|---|---|
| kubelet 정지 | inactive (dead) | `systemctl start kubelet && systemctl enable kubelet` |
| kubelet config 오타 | failed to load Kubelet config file, `/var/lib/kubelet/config.yaml` | YAML 수정 후 restart |
| kubelet kubeconfig 잘못 | connection refused to https://<wrong>:6443 | `/etc/kubernetes/kubelet.conf` server 주소/포트 수정 |
| 인증서 만료/경로 오류 | x509, no such file | `--client-ca-file` 경로 확인(`/etc/kubernetes/pki/ca.crt`) |
| containerd 정지 | failed to connect to CRI | `systemctl start containerd` |
| CNI 없음 | cni plugin not initialized, NetworkPluginNotReady | CNI 매니페스트 apply, `/etc/cni/net.d` 확인 |
| 디스크/메모리 압박 | DiskPressure/MemoryPressure | 정리 |
| swap on | running with swap on is not supported | `swapoff -a` |

kubelet 실행 옵션 파일: `/var/lib/kubelet/kubeadm-flags.env`, `/etc/systemd/system/kubelet.service.d/10-kubeadm.conf`. 수정 후 `systemctl daemon-reload && systemctl restart kubelet`.

## 4. 컨트롤플레인 컴포넌트

전부 static pod. 매니페스트 `/etc/kubernetes/manifests/`. 파일 저장 즉시 kubelet이 재시작.

```bash
ssh cp01
ls /etc/kubernetes/manifests/
crictl ps -a | grep -E "apiserver|etcd|scheduler|controller"
crictl logs <container-id>
ls /var/log/pods/kube-system_kube-apiserver-*/kube-apiserver/   # 로그 파일
journalctl -u kubelet | grep -i apiserver
```

| 컴포넌트 | 증상 | 흔한 고장 |
|---|---|---|
| kube-apiserver | `kubectl` 전체 connection refused | 매니페스트 오타(이미지, 플래그명 `--etcd-servers`, 인증서 경로, 포트), etcd 안 뜸 |
| etcd | apiserver 로그 "connection refused 2379" | data-dir 경로, 인증서, listen 주소 |
| kube-scheduler | 새 Pod 영원히 Pending, nodeName 비어있음 | 매니페스트 이미지/커맨드 오타, kubeconfig 경로 |
| kube-controller-manager | Deployment가 Pod 안 만듦, RS 안 생김, 노드 삭제 시 재배치 없음 | 매니페스트 오타, kubeconfig |
| kube-proxy | Service IP 접근 불가 | DS Pod 상태, ConfigMap |
| CoreDNS | 이름 해석 실패 | Deployment Pod, Corefile |

매니페스트 오타 찾는 법: `crictl ps -a` 에서 Exited 컨테이너 → `crictl logs`. kubelet 이 아예 컨테이너 못 만들면(YAML 문법 오류) `journalctl -u kubelet | grep manifests`.

apiserver 죽으면 `kubectl` 안 됨 → 노드에서 `crictl`, `/var/log/pods` 로 진단. 고친 뒤 `k get po -n kube-system` 확인.

## 5. 리소스 모니터링

```bash
k top no
k top po -A --sort-by=memory
k top po -n app --containers
k describe no node01 | grep -A8 "Allocated resources"
k get po -A -o custom-columns=NS:.metadata.namespace,NAME:.metadata.name,CPU_REQ:.spec.containers[*].resources.requests.cpu
```

- metrics-server 없으면 `error: Metrics API not available`. 설치는 문서/GitHub 매니페스트.
- 문제 유형: "CPU 가장 많이 쓰는 Pod 이름을 /opt/high-cpu.txt 에 저장" → `k top po -A --sort-by=cpu | head -2`.

## 6. 로그

```bash
k logs X                          # 단일 컨테이너
k logs X -c side                  # 멀티
k logs X --all-containers
k logs X --previous               # 죽은 이전 컨테이너
k logs X --since=1h --tail=100 -f
k logs -l app=web --prefix
k logs deploy/web
k logs X | grep -i error > /opt/errors.txt
```

- 컨테이너 로그 파일(노드): `/var/log/pods/<ns>_<pod>_<uid>/<container>/0.log`, 심볼릭 `/var/log/containers/`.
- 앱이 파일로만 로그 남기면 sidecar로 `tail -f` 해서 stdout으로 스트리밍(문제 유형).
- 시스템 로그: `journalctl -u kubelet`, `journalctl -u containerd`.

sidecar 로그 스트리밍 예:

```yaml
containers:
  - name: app
    image: busybox
    command: ["sh","-c","while true; do date >> /var/log/app.log; sleep 1; done"]
    volumeMounts: [{name: logs, mountPath: /var/log}]
  - name: log-shipper
    image: busybox
    command: ["sh","-c","tail -F /var/log/app.log"]
    volumeMounts: [{name: logs, mountPath: /var/log}]
volumes:
  - name: logs
    emptyDir: {}
```

## 7. 서비스·네트워크 트러블슈팅

```bash
k get svc,ep X                                      # endpoints 없음 → selector/targetPort/readiness
k get po -l <selector> -o wide
k describe svc X
k run tmp --rm -it --image=nicolaka/netshoot --restart=Never -- bash
  curl <svc-name>:<port>; curl <pod-ip>:<port>; nslookup <svc>; dig <svc>.<ns>.svc.cluster.local
k get netpol -A ; k describe netpol X
k -n kube-system get po -l k8s-app=kube-dns ; k -n kube-system logs -l k8s-app=kube-dns
k -n kube-system get ds kube-proxy ; k -n kube-system logs -l k8s-app=kube-proxy
k get po -n kube-system | grep -iE "calico|flannel|cilium|weave"
```

체크 순서: Endpoints → Pod 직접 curl → DNS → NetworkPolicy → kube-proxy → CNI.

Ingress 안 됨: `k get ingressclass` 이름 일치? `k describe ing` Address/backends? 컨트롤러 Pod 로그?

## 8. 권한/인증 문제

```bash
k auth can-i <verb> <resource> --as=<user> -n <ns>
k auth can-i --list --as=system:serviceaccount:<ns>:<sa>
k get rolebinding,clusterrolebinding -A -o wide | grep <subject>
```

"Forbidden" → RBAC. "Unauthorized" → 인증서/토큰. kubeconfig `k config view`.

## 9. 자주 나오는 트러블슈팅 시나리오

1. **Deployment Pod가 안 뜸** → `k describe po`: 이미지 오타 / CM 없음 / 리소스 초과 / nodeSelector 불일치.
2. **노드 NotReady** → kubelet 정지 또는 config 오류. `systemctl`, `journalctl`.
3. **kube-scheduler 매니페스트 깨짐** → 신규 Pod Pending, `/etc/kubernetes/manifests/kube-scheduler.yaml` 수정.
4. **apiserver 안 뜸** → 매니페스트 플래그/인증서 경로 오타.
5. **Service 접속 불가** → selector/targetPort 불일치.
6. **DNS 실패** → CoreDNS Pod 죽음 / kube-dns svc 삭제 / NetworkPolicy가 53 차단.
7. **PVC Pending** → SC/용량/모드 불일치.
8. **CrashLoopBackOff** → `k logs --previous`, command/args, probe.
9. **etcd 복원 후 이상** → data-dir hostPath 경로.
10. **워커 노드가 조인 안 됨** → 토큰 만료, 포트, 인증서 해시.

## 시험 팁

- 트러블슈팅 문제는 **고쳐라**지 **재생성하라**가 아님. 리소스 삭제 후 재생성하면 채점 스크립트가 UID/이름 체크에서 실패할 수 있음. 가능하면 `k edit` / 파일 수정.
- 노드 작업 후 `exit` 잊지 않기.
- 컨트롤플레인 static pod 수정 후 30초~1분 대기. `watch crictl ps`.
- `k get events -A --sort-by=.lastTimestamp | tail -20` 이 가장 빠른 힌트.
