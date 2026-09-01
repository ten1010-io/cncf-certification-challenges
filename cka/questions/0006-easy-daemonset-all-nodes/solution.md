# 풀이 — 0006 DaemonSet 전 노드 배치

`k create` 에 DaemonSet 은 없다. Deployment 를 뼈대로 만들어 고친다.

```bash
k describe no cka-control-plane | grep Taints      # node-role.kubernetes.io/control-plane:NoSchedule
k -n monitoring create deploy node-agent --image=busybox:1.36 --dry-run=client -o yaml --command -- sleep 3600 > ds.yaml
# kind: DaemonSet, replicas/strategy/status 제거, tolerations 추가
```

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: node-agent
  namespace: monitoring
  labels: {app: node-agent}
spec:
  selector:
    matchLabels: {app: node-agent}
  template:
    metadata:
      labels: {app: node-agent}
    spec:
      tolerations:
        - key: node-role.kubernetes.io/control-plane
          operator: Exists
          effect: NoSchedule
      containers:
        - name: node-agent
          image: busybox:1.36
          command: ["sleep", "3600"]
```

```bash
k apply -f ds.yaml
k -n monitoring get ds node-agent        # DESIRED 3 / READY 3
k -n monitoring get po -o wide           # 노드 3개 각각 1개
```

## 함정

- 이 kind 클러스터의 control-plane 에는 실제 kubeadm 클러스터와 똑같이 `node-role.kubernetes.io/control-plane:NoSchedule` taint 가 있다. toleration 없으면 DESIRED 2 로 끝나고 "모든 노드" 조건 위반. 시험에서도 항상 있다고 보고 넣는다.
- 오래된 문서 예제는 key 가 `node-role.kubernetes.io/master`. 현재 클러스터는 `control-plane` 이므로 `describe no` 로 실제 taint 를 확인한다.
- Deployment 를 DaemonSet 으로 바꿀 때 `replicas`, `strategy` 를 남기면 `apply` 가 unknown field 로 실패한다.
- `k -n monitoring get ds` 에서 DESIRED 가 노드 수와 같아야 한다. READY 만 보면 taint 로 제외된 노드를 놓친다.
