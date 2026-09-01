# 풀이 — 0029 PVC Pending (accessModes 불일치)

```bash
k -n logs describe pvc logs-pvc     # no persistent volumes available for this claim ... accessModes
k get pv pv-logs                    # 2Gi, RWX, sc logs, Available
k -n logs get pvc logs-pvc -o yaml > pvc.yaml
k -n logs get pod log-writer -o yaml > pod.yaml
```

`pvc.yaml` 의 `accessModes` 를 `ReadWriteMany` 로 바꾸고 `status`, `uid`, `resourceVersion` 등 메타는 지운다. `accessModes` 는 불변 필드라 재생성해야 한다.

```bash
k -n logs delete pod log-writer --force --grace-period=0   # PVC 를 쓰는 Pod 가 있으면 PVC 삭제가 Terminating 에 걸림
k -n logs delete pvc logs-pvc
k apply -f pvc.yaml
k -n logs get pvc logs-pvc                                 # Bound  pv-logs
k apply -f pod.yaml                                        # 또는 setup 과 동일한 spec 으로 재작성
k -n logs get pod log-writer                               # Running
```

`k replace --force -f pvc.yaml` 는 삭제+생성을 한 번에 한다.

## 함정

- PVC 의 `accessModes` 는 PV 의 accessModes 부분집합이어야 바인딩된다. RWO 요청에 RWX PV 는 매칭되지 않는다 (RWX PV 가 RWO 를 "포함"하는 게 아니다).
- `k edit pvc` 로 accessModes 를 바꾸면 `spec is immutable` 로 거부된다. 삭제 후 재생성.
- Pod 가 PVC 를 참조하는 동안은 `kubernetes.io/pvc-protection` finalizer 때문에 PVC 가 Terminating 에서 멈춘다. Pod 먼저 삭제.
- PV 쪽 accessModes 를 RWO 로 고치는 게 더 빠르지만 지문 위반. uid 와 accessModes 로 채점한다.
