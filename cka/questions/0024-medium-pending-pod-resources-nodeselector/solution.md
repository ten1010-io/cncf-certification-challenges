# 풀이 — 0024 Pending Pod 해결 (리소스 요구 + nodeSelector)

```bash
k -n heavy get po                                   # Pending
k -n heavy describe po -l app=heavy | tail -5
#   0/3 nodes are available: 3 node(s) didn't match Pod's node affinity/selector, ... Insufficient memory
k get no -L disktype                                # 아무 노드에도 disktype 라벨 없음
k label no cka-worker disktype=ssd
k -n heavy set resources deploy heavy --requests=cpu=100m,memory=128Mi --limits=cpu=100m,memory=128Mi
k -n heavy get po -o wide                           # Running, NODE cka-worker
```

`k edit deploy heavy` 로 `resources` 블록을 직접 고쳐도 된다. nodeSelector 는 그대로 둔다.

## 함정

- 원인이 **두 개**다. 이벤트 메시지에 `didn't match node affinity/selector` 와 `Insufficient memory` 가 함께 나온다. 하나만 고치면 여전히 Pending.
- nodeSelector 를 지우면 Pod 는 뜨지만 "SSD 노드에서만" 조건과 "nodeSelector 유지" 지시를 위반해 0점.
- `set resources` 는 `--requests` 와 `--limits` 를 따로 준다. limits 를 안 주면 기존 64Gi limit 가 남아 requests 보다 큰 상태로 남는다 (유효하지만 지문 위반).
- 라벨은 `cka-worker` (worker1) 에 붙인다. `cka-worker2` 에 붙이면 Pod 가 다른 노드로 가서 채점 실패.
