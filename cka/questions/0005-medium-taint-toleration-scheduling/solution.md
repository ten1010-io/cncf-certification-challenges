# 풀이 — 0005 taint/toleration + nodeSelector 스케줄링

```bash
k describe no cka-worker | grep -A2 -E "^Taints|^Labels"      # dedicated=batch:NoSchedule / workload=batch
k -n batch run batch-runner --image=busybox:1.36 --dry-run=client -o yaml --command -- sleep 3600 > pod.yaml
```

`spec` 에 두 항목을 추가한다.

```yaml
spec:
  nodeSelector:
    workload: batch
  tolerations:
    - key: dedicated
      operator: Equal
      value: batch
      effect: NoSchedule
  containers:
    - name: batch-runner
      image: busybox:1.36
      command: ["sleep", "3600"]
```

```bash
k apply -f pod.yaml
k -n batch get po batch-runner -o wide     # NODE: cka-worker
```

## 함정

- toleration 은 "그 노드에 **갈 수 있다**" 일 뿐이다. toleration 만 있으면 `cka-worker2` 로 갈 수 있다. **반드시** 라는 조건은 `nodeSelector`(또는 `requiredDuringScheduling` nodeAffinity)로 고정한다.
- 반대로 nodeSelector 만 있으면 taint 때문에 `Pending`. 둘 다 필요하다.
- `nodeName: cka-worker` 는 스케줄러를 우회하므로 지문 위반. 채점은 nodeSelector/affinity 존재를 본다.
- `operator: Equal` 이면 `value` 가 정확히 `batch` 여야 한다. 값 오타가 잦으면 `operator: Exists`(value 생략)가 안전하다.
