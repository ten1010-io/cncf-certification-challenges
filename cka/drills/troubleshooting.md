# Drills — Troubleshooting

각 드릴은 `고장 주입` 명령을 실행 후 원인을 찾아 고친다. 정답 보기 전 5분.
준비: `kubectl create ns drill-t --dry-run=client -o yaml | kubectl apply -f -`
정리: `kubectl delete ns drill-t` + 각 드릴의 복구 명령.

---

### T1. 고장 주입:
```bash
kubectl -n drill-t create deploy t1 --image=nginx:1.25 --replicas=2
kubectl -n drill-t set image deploy/t1 nginx=nginx:1.25-doesnotexist
```
Pod 가 안 뜬다. 고쳐라.
<details><summary>정답</summary>

```bash
k -n drill-t get po                         # ImagePullBackOff
k -n drill-t describe po <p> | tail -5      # manifest unknown
k -n drill-t set image deploy/t1 nginx=nginx:1.25
```
</details>

### T2. 고장 주입:
```bash
kubectl -n drill-t run t2 --image=busybox:1.36 --command -- sh -c "echo starting; exit 3"
```
CrashLoopBackOff. 원인 확인 후 `sleep 3600` 으로 계속 뜨게 수정.
<details><summary>정답</summary>

```bash
k -n drill-t logs t2 --previous             # starting
k -n drill-t get po t2 -o jsonpath='{.status.containerStatuses[0].lastState.terminated.exitCode}'   # 3
k -n drill-t get po t2 -o yaml > t2.yaml    # command 수정 → sleep 3600
k replace --force -f t2.yaml                # Pod command 는 불변
```
</details>

### T3. 고장 주입:
```bash
cat <<'Y' | kubectl -n drill-t apply -f -
apiVersion: v1
kind: Pod
metadata: {name: t3}
spec:
  containers:
    - name: c
      image: nginx:1.25
      env:
        - name: MODE
          valueFrom: {configMapKeyRef: {name: t3-cfg, key: mode}}
Y
```
Pod 상태와 원인, 수정.
<details><summary>정답</summary>

`CreateContainerConfigError`. `k describe po t3` → configmap "t3-cfg" not found.
`k -n drill-t create cm t3-cfg --from-literal=mode=prod` → 자동 복구.
</details>

### T4. 고장 주입:
```bash
kubectl -n drill-t run t4 --image=nginx:1.25 --overrides='{"spec":{"nodeSelector":{"gpu":"true"}}}'
```
Pending. 노드 라벨을 바꾸지 않고 Pod 만 고쳐 Running 시키기.
<details><summary>정답</summary>

`k describe po t4` → didn't match Pod's node affinity/selector. nodeSelector 는 불변 → yaml 추출 후 `nodeSelector` 삭제, `k replace --force`.
</details>

### T5. 고장 주입:
```bash
kubectl -n drill-t create deploy t5 --image=nginx:1.25 --port=80
kubectl -n drill-t expose deploy t5 --port=80 --target-port=8080
```
`t5` 서비스로 접속 실패. 수정.
<details><summary>정답</summary>

```bash
k -n drill-t get ep t5          # IP:8080 (엔드포인트는 있으나 포트 틀림)
k -n drill-t patch svc t5 -p '{"spec":{"ports":[{"port":80,"targetPort":80}]}}'
```
</details>

### T6. 고장 주입:
```bash
kubectl -n drill-t create deploy t6 --image=nginx:1.25 --port=80
kubectl -n drill-t patch deploy t6 -p '{"spec":{"template":{"spec":{"containers":[{"name":"nginx","readinessProbe":{"httpGet":{"path":"/nope","port":80}}}]}}}}'
kubectl -n drill-t expose deploy t6 --port=80
```
Endpoints 비어있음. 원인과 수정.
<details><summary>정답</summary>

`k get po` READY 0/1. `k describe po` → Readiness probe failed: 404. probe path 를 `/` 로 수정: `k edit deploy t6`.
</details>

### T7. 고장 주입 (노드):
```bash
docker exec cka-worker systemctl stop kubelet
```
노드 NotReady. 복구.
<details><summary>정답</summary>

```bash
k get no; k describe no cka-worker | grep -A3 Ready
docker exec cka-worker systemctl start kubelet
```
</details>

### T8. 고장 주입 (노드):
```bash
docker exec cka-worker sed -i 's/staticPodPath: \/etc\/kubernetes\/manifests/staticPodPath: \/etc\/kubernetes\/manifest/' /var/lib/kubelet/config.yaml
docker exec cka-worker systemctl restart kubelet
```
worker 에 static pod 를 만들었는데 안 뜬다. 원인 찾아 복구.
<details><summary>정답</summary>

```bash
docker exec -it cka-worker bash
  grep staticPodPath /var/lib/kubelet/config.yaml     # /etc/kubernetes/manifest (오타)
  sed -i 's#manifest$#manifests#' /var/lib/kubelet/config.yaml
  systemctl restart kubelet
```
</details>

### T9. 고장 주입 (control-plane, 신중히):
```bash
docker exec cka-control-plane sed -i 's/kube-controller-manager:v/kube-controller-manager:vv/' /etc/kubernetes/manifests/kube-controller-manager.yaml
kubectl -n drill-t create deploy t9 --image=nginx:1.25
```
Deployment 가 Pod 를 안 만든다. 원인과 복구.
<details><summary>정답</summary>

```bash
k -n drill-t get deploy,rs,po t9                 # RS 없음 → controller-manager
k -n kube-system get po | grep controller        # ImagePullBackOff / ErrImagePull
docker exec cka-control-plane sed -i 's/:vv/:v/' /etc/kubernetes/manifests/kube-controller-manager.yaml
```
Deployment→RS 는 controller-manager, RS→Pod 배치는 scheduler. 어느 단계가 비었는지로 어떤 컴포넌트인지 판단.
</details>

### T10. 고장 주입:
```bash
kubectl -n kube-system scale deploy coredns --replicas=0
```
DNS 안 됨. 복구.
<details><summary>정답</summary>

```bash
k run t --rm -it --image=busybox:1.36 --restart=Never -- nslookup kubernetes   # fail
k -n kube-system get deploy coredns        # 0/0
k -n kube-system scale deploy coredns --replicas=2
```
</details>

### T11. 고장 주입:
```bash
cat <<'Y' | kubectl -n drill-t apply -f -
apiVersion: v1
kind: Pod
metadata: {name: t11}
spec:
  containers:
    - name: c
      image: polinux/stress
      command: ["stress","--vm","1","--vm-bytes","250M","--vm-hang","1"]
      resources: {limits: {memory: 100Mi}}
Y
```
Pod 상태와 원인. limit 을 300Mi 로 올려 해결.
<details><summary>정답</summary>

`OOMKilled` → CrashLoopBackOff. `k describe po t11 | grep -A3 "Last State"`. resources 는 Pod 불변 → yaml 수정 후 `k replace --force`.
</details>

### T12. ns `drill-t` 에서 CPU 상위 1개 Pod, 노드 중 메모리 사용률 최고 노드를 각각 파일에.
<details><summary>정답</summary>

```bash
k top po -n drill-t --sort-by=cpu --no-headers | head -1 | awk '{print $1}' > /tmp/top-pod.txt
k top no --sort-by=memory --no-headers | head -1 | awk '{print $1}' > /tmp/top-node.txt
```
</details>

### T13. `t1` 의 모든 Pod 로그에서 `error` 가 포함된 줄만 `/tmp/t1-errors.txt` 에.
<details><summary>정답</summary>

```bash
k -n drill-t logs -l app=t1 --all-containers | grep -i error > /tmp/t1-errors.txt
```
</details>

### T14. kube-apiserver 가 죽어 `kubectl` 이 안 될 때 진단 명령 4개.
<details><summary>정답</summary>

control-plane 노드에서:
1. `sudo crictl ps -a | grep apiserver` (Exited?)
2. `sudo crictl logs <id>`
3. `sudo journalctl -u kubelet | grep -i apiserver` (매니페스트 파싱 오류)
4. `ls /var/log/pods/kube-system_kube-apiserver*/kube-apiserver/`
매니페스트 `/etc/kubernetes/manifests/kube-apiserver.yaml` 플래그·인증서 경로·etcd 주소 확인.
</details>
