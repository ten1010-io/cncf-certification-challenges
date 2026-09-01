# Drills — Workloads & Scheduling

준비:
```bash
kubectl create ns drill-w --dry-run=client -o yaml | kubectl apply -f -
kubectl label no cka-worker tier=gold --overwrite
kubectl taint no cka-worker2 env=test:NoSchedule --overwrite
```
정리: `kubectl delete ns drill-w; kubectl taint no cka-worker2 env-; kubectl label no cka-worker tier-`

---

### W1. Deployment `api` 를 ns `drill-w` 에 생성. 이미지 `nginx:1.24`, replicas 4, 라벨 `app=api,tier=backend`, 컨테이너 포트 8080.
<details><summary>정답</summary>

```bash
k -n drill-w create deploy api --image=nginx:1.24 --replicas=4 --port=8080 $do > api.yaml
# labels 에 tier: backend 추가 (metadata.labels, selector.matchLabels, template.metadata.labels 세 곳)
k apply -f api.yaml
```
</details>

### W2. `api` 이미지를 `nginx:1.25` 로 변경하고 change-cause 를 "bump to 1.25" 로 기록. 그 후 히스토리에서 revision 1 로 롤백.
<details><summary>정답</summary>

```bash
k -n drill-w set image deploy/api nginx=nginx:1.25
k -n drill-w annotate deploy/api kubernetes.io/change-cause="bump to 1.25"
k -n drill-w rollout history deploy/api
k -n drill-w rollout undo deploy/api --to-revision=1
```
</details>

### W3. `api` 의 롤링 업데이트 전략을 maxSurge 1, maxUnavailable 0 으로 변경.
<details><summary>정답</summary>

```bash
k -n drill-w patch deploy api -p '{"spec":{"strategy":{"rollingUpdate":{"maxSurge":1,"maxUnavailable":0}}}}'
```
</details>

### W4. Pod `gold-pod`(nginx) 를 라벨 `tier=gold` 인 노드에만 배치. nodeAffinity required 사용.
<details><summary>정답</summary>

```yaml
spec:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
          - matchExpressions:
              - {key: tier, operator: In, values: [gold]}
```
</details>

### W5. Pod `test-pod`(busybox sleep 3600) 를 taint `env=test:NoSchedule` 가 있는 `cka-worker2` 에 배치.
<details><summary>정답</summary>

```yaml
spec:
  nodeName 사용 금지면:
  nodeSelector: {kubernetes.io/hostname: cka-worker2}
  tolerations:
    - {key: env, operator: Equal, value: test, effect: NoSchedule}
```
</details>

### W6. ConfigMap `app-cfg` (`LOG_LEVEL=debug`, `MODE=dev`) 생성. Pod `cfg-pod`(busybox) 에 전체를 env 로 주입하고, 동시에 `/etc/cfg` 에 파일로 마운트.
<details><summary>정답</summary>

```bash
k -n drill-w create cm app-cfg --from-literal=LOG_LEVEL=debug --from-literal=MODE=dev
```
```yaml
containers:
  - name: c
    image: busybox:1.36
    command: ["sleep","3600"]
    envFrom: [{configMapRef: {name: app-cfg}}]
    volumeMounts: [{name: cfg, mountPath: /etc/cfg}]
volumes:
  - name: cfg
    configMap: {name: app-cfg}
```
</details>

### W7. Deployment `api` 에 HPA: min 2 max 8, CPU 50%. (requests 없으면 먼저 추가)
<details><summary>정답</summary>

```bash
k -n drill-w set resources deploy api --requests=cpu=100m
k -n drill-w autoscale deploy api --min=2 --max=8 --cpu-percent=50
```
</details>

### W8. DaemonSet `fluentd`(busybox sleep) 를 ns `drill-w` 에 생성. control-plane 포함 전 노드 + `env=test` taint 노드도 포함.
<details><summary>정답</summary>

```yaml
tolerations:
  - {key: node-role.kubernetes.io/control-plane, operator: Exists, effect: NoSchedule}
  - {key: env, operator: Equal, value: test, effect: NoSchedule}
# 또는 모든 taint 허용: - {operator: Exists}
```
</details>

### W9. `cka-worker` 노드에 static pod `static-web`(nginx) 생성.
<details><summary>정답</summary>

```bash
docker exec -it cka-worker bash
  grep staticPodPath /var/lib/kubelet/config.yaml   # /etc/kubernetes/manifests
  cat <<'Y' | tee /etc/kubernetes/manifests/static-web.yaml
apiVersion: v1
kind: Pod
metadata: {name: static-web}
spec:
  containers: [{name: web, image: nginx:1.25}]
Y
  exit
k get po -A | grep static-web    # static-web-cka-worker
```
</details>

### W10. Pod `probe-pod`(nginx): liveness httpGet `/` 80 (5초 후 시작, 10초 주기), readiness tcpSocket 80, startup exec `cat /usr/share/nginx/html/index.html` failureThreshold 10.
<details><summary>정답</summary>

```yaml
livenessProbe:
  httpGet: {path: /, port: 80}
  initialDelaySeconds: 5
  periodSeconds: 10
readinessProbe:
  tcpSocket: {port: 80}
startupProbe:
  exec: {command: ["cat","/usr/share/nginx/html/index.html"]}
  failureThreshold: 10
  periodSeconds: 5
```
</details>

### W11. Job `hash`: busybox 로 `echo hello | md5sum` 5회 완료, 동시 2개. CronJob `tick`: 매 분 `date` 출력, 실패 히스토리 1개만 보관.
<details><summary>정답</summary>

```bash
k -n drill-w create job hash --image=busybox:1.36 $do -- sh -c "echo hello | md5sum" > job.yaml
# spec: completions: 5, parallelism: 2
k -n drill-w create cronjob tick --image=busybox:1.36 --schedule="* * * * *" $do -- date > cj.yaml
# spec: failedJobsHistoryLimit: 1
```
</details>

### W12. Pod `multi`: 컨테이너 `web`(nginx) + `sidecar`(busybox, `wget -qO- localhost` 를 10초마다 출력). Pod 내부 localhost 공유 확인.
<details><summary>정답</summary>

```yaml
containers:
  - {name: web, image: nginx:1.25}
  - name: sidecar
    image: busybox:1.36
    command: ["sh","-c","while true; do wget -qO- localhost; sleep 10; done"]
```
같은 Pod 컨테이너는 network namespace 공유 → localhost.
</details>
