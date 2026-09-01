# 02. Workloads & Scheduling (15%)

## 커리큘럼 항목

- Deployment, 롤링 업데이트/롤백
- ConfigMap, Secret으로 앱 설정
- 워크로드 오토스케일링(HPA)
- 자가치유 프리미티브(probe, ReplicaSet, restartPolicy)
- Pod admission과 스케줄링(requests/limits, nodeSelector, affinity, taint/toleration, topology)

---

## 1. Pod 기본

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app
  labels: {app: web}
spec:
  restartPolicy: Always          # Always | OnFailure | Never
  serviceAccountName: app-sa
  nodeSelector: {disk: ssd}
  initContainers:
    - name: init
      image: busybox
      command: ["sh","-c","until nslookup db; do sleep 2; done"]
  containers:
    - name: web
      image: nginx:1.25
      ports: [{containerPort: 80}]
      command: ["nginx"]                 # ENTRYPOINT 대체
      args: ["-g","daemon off;"]         # CMD 대체
      env:
        - name: KEY
          value: "v"
        - name: FROM_CM
          valueFrom: {configMapKeyRef: {name: cfg, key: k}}
        - name: FROM_SEC
          valueFrom: {secretKeyRef: {name: sec, key: password}}
      envFrom:
        - configMapRef: {name: cfg}
        - secretRef: {name: sec}
      resources:
        requests: {cpu: 100m, memory: 128Mi}
        limits:   {cpu: 500m, memory: 256Mi}
      volumeMounts:
        - {name: cfg-vol, mountPath: /etc/cfg, readOnly: true}
        - {name: data, mountPath: /data}
      livenessProbe:
        httpGet: {path: /healthz, port: 80}
        initialDelaySeconds: 5
        periodSeconds: 10
      readinessProbe:
        tcpSocket: {port: 80}
      startupProbe:
        exec: {command: ["cat","/tmp/ready"]}
        failureThreshold: 30
        periodSeconds: 10
      securityContext:
        runAsUser: 1000
        allowPrivilegeEscalation: false
        capabilities: {add: ["NET_ADMIN"]}
  securityContext:
    runAsNonRoot: true
    fsGroup: 2000
  volumes:
    - name: cfg-vol
      configMap: {name: cfg}
    - name: data
      emptyDir: {}
    - name: sec-vol
      secret: {secretName: sec}
    - name: host
      hostPath: {path: /var/log, type: Directory}
    - name: pvc
      persistentVolumeClaim: {claimName: my-pvc}
```

멀티컨테이너 패턴: sidecar(로그 수집), ambassador(프록시), adapter(포맷 변환). 1.29+ sidecar = `initContainers` 에 `restartPolicy: Always`.

## 2. Deployment

```bash
k create deploy web --image=nginx:1.24 --replicas=3 --port=80
k set image deploy/web nginx=nginx:1.25 --record   # (--record deprecated, annotation 수동)
k annotate deploy/web kubernetes.io/change-cause="update to 1.25"
k rollout status deploy/web
k rollout history deploy/web
k rollout undo deploy/web [--to-revision=N]
k scale deploy web --replicas=5
```

전략:

```yaml
spec:
  strategy:
    type: RollingUpdate          # 또는 Recreate
    rollingUpdate:
      maxSurge: 25%              # 초과 생성 허용
      maxUnavailable: 25%        # 동시 다운 허용
  revisionHistoryLimit: 10
  minReadySeconds: 5
```

Deployment → ReplicaSet → Pod. 롤아웃마다 새 RS. 롤백 = 이전 RS 스케일업.

## 3. 기타 워크로드

| 리소스 | 용도 | 포인트 |
|---|---|---|
| ReplicaSet | 복제 수 유지 | 직접 안 씀. selector와 template.labels 일치 필수 |
| DaemonSet | 노드당 1 Pod | `k create deploy` 로 만든 뒤 kind/replicas/strategy 수정. control-plane에 띄우려면 toleration 추가 |
| StatefulSet | 순서/고정 이름/PVC 템플릿 | `serviceName` headless svc 필요. `volumeClaimTemplates` |
| Job | 1회 실행 | `completions`, `parallelism`, `backoffLimit`, `activeDeadlineSeconds`, `restartPolicy: Never/OnFailure` |
| CronJob | 스케줄 | `schedule`, `concurrencyPolicy`, `successfulJobsHistoryLimit`, `startingDeadlineSeconds` |

DaemonSet control-plane 배치용 toleration:

```yaml
tolerations:
  - key: node-role.kubernetes.io/control-plane
    operator: Exists
    effect: NoSchedule
```

## 4. ConfigMap / Secret

```bash
k create cm cfg --from-literal=A=1 --from-literal=B=2
k create cm cfg2 --from-file=app.conf                # key=파일명
k create cm cfg3 --from-file=mykey=app.conf
k create cm cfg4 --from-env-file=.env
k create secret generic sec --from-literal=password=p@ss
k create secret docker-registry regcred --docker-server=... --docker-username=... --docker-password=...
k create secret tls tls --cert=c.crt --key=c.key
echo -n 'p@ss' | base64 ; echo cEBzcw== | base64 -d
```

주입 3가지: `env.valueFrom`, `envFrom`, `volumes`(파일). 볼륨 마운트는 CM 수정 시 자동 갱신(subPath 제외), env는 Pod 재시작 필요.
`immutable: true` 로 변경 금지 가능. Secret은 base64일 뿐 암호화 아님(etcd 암호화는 EncryptionConfiguration).

## 5. 스케줄링

### requests / limits

- requests → 스케줄링 기준. limits → cgroup 제한. CPU 초과 = throttle, 메모리 초과 = OOMKilled.
- QoS: Guaranteed(req=lim 전부) / Burstable / BestEffort.
- LimitRange(ns 기본값/상한), ResourceQuota(ns 총량).

### nodeSelector / nodeName

```yaml
spec:
  nodeName: node01            # 스케줄러 우회
  nodeSelector: {disk: ssd}
```

### Affinity

```yaml
affinity:
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
        - matchExpressions:
            - {key: disk, operator: In, values: [ssd, nvme]}   # In, NotIn, Exists, DoesNotExist, Gt, Lt
    preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 10
        preference:
          matchExpressions: [{key: zone, operator: In, values: [a]}]
  podAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector: {matchLabels: {app: cache}}
        topologyKey: kubernetes.io/hostname
  podAntiAffinity:
    preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 100
        podAffinityTerm:
          labelSelector: {matchLabels: {app: web}}
          topologyKey: kubernetes.io/hostname
```

### Taint / Toleration

```bash
k taint no node01 dedicated=gpu:NoSchedule        # NoSchedule | PreferNoSchedule | NoExecute
k taint no node01 dedicated-                      # 제거
k describe no node01 | grep Taint
```

```yaml
tolerations:
  - key: dedicated
    operator: Equal          # Equal(value 필요) | Exists
    value: gpu
    effect: NoSchedule
  - key: node.kubernetes.io/not-ready
    operator: Exists
    effect: NoExecute
    tolerationSeconds: 300
```

Taint는 "노드가 거부", toleration은 "Pod가 허용". toleration 있어도 그 노드로 **강제되진 않음** → nodeAffinity 함께 사용.

### Topology Spread

```yaml
topologySpreadConstraints:
  - maxSkew: 1
    topologyKey: kubernetes.io/hostname
    whenUnsatisfiable: DoNotSchedule     # 또는 ScheduleAnyway
    labelSelector: {matchLabels: {app: web}}
```

### PriorityClass

```yaml
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata: {name: high}
value: 1000000
preemptionPolicy: PreemptLowerPriority
---
# Pod: spec.priorityClassName: high
```

### Static Pod

- kubelet이 `/etc/kubernetes/manifests/`(staticPodPath) 직접 감시. API 서버 통해 삭제 불가. 이름 뒤에 `-<nodename>` 붙음.
- 문제: "node01에 static pod 생성" → `ssh node01`, 매니페스트 파일 작성, `exit`, `k get po` 확인.

### 스케줄러 관련 문제

- 여러 스케줄러: Pod `spec.schedulerName`.
- 스케줄러 죽으면 Pod Pending, `nodeName` 직접 지정하면 kubelet이 실행.

## 6. HPA

```bash
k autoscale deploy web --min=2 --max=10 --cpu-percent=70
k get hpa
```

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata: {name: web}
spec:
  scaleTargetRef: {apiVersion: apps/v1, kind: Deployment, name: web}
  minReplicas: 2
  maxReplicas: 10
  metrics:
    - type: Resource
      resource:
        name: cpu
        target: {type: Utilization, averageUtilization: 70}
    - type: Resource
      resource:
        name: memory
        target: {type: AverageValue, averageValue: 200Mi}
  behavior:
    scaleDown:
      stabilizationWindowSeconds: 300
```

- metrics-server 필수. 없으면 `TARGETS <unknown>`. Pod에 `requests` 없으면 CPU % 계산 불가.
- VPA는 별도 설치(시험 범위 밖일 가능성 높음, 개념만).

## 7. 자가치유

- restartPolicy + kubelet 재시작(exponential backoff → CrashLoopBackOff).
- ReplicaSet이 replicas 유지. 노드 죽으면 5분(pod-eviction-timeout / taint-based eviction) 후 재배치.
- Probe: liveness(재시작), readiness(Service endpoint 제외), startup(느린 시작 보호).
- PodDisruptionBudget: drain 시 최소 가용 보장. `k create pdb web --selector=app=web --min-available=2`.

## 시험 빈출 정리

1. Deployment 생성 → 이미지 업데이트 → 롤백, 스케일
2. ConfigMap/Secret 만들어 env·볼륨으로 주입
3. nodeSelector / nodeAffinity로 특정 노드 배치
4. taint 걸린 노드에 toleration으로 배치
5. DaemonSet 생성(control-plane 포함/제외)
6. Static Pod 생성
7. 멀티컨테이너 Pod(sidecar) + 공유 emptyDir
8. HPA 생성
9. Pod가 Pending인 이유(리소스/taint/selector) 찾아 수정
10. Job/CronJob 생성
