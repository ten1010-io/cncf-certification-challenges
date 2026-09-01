# 풀이 — 0033 노드 유지보수 (drain)

```bash
k get po -A -o wide --field-selector spec.nodeName=cka-worker2     # 내보낼 Pod 확인
k drain cka-worker2 --ignore-daemonsets --delete-emptydir-data
k get no                                                           # cka-worker2  Ready,SchedulingDisabled
k get po -A -o wide --field-selector spec.nodeName=cka-worker2     # DaemonSet Pod 만 남음
```

컨트롤러 없는 단독 Pod 가 있어 drain 이 거부되면 `--force` 를 추가한다 (해당 Pod 는 재생성되지 않고 삭제된다).

## 함정

- `k cordon` 은 새 스케줄만 막고 기존 Pod 는 그대로다. "모든 Pod 를 내보낸다" = `drain` (drain 이 cordon 을 포함).
- `--ignore-daemonsets` 없이는 DaemonSet Pod 때문에 drain 이 중단된다. `--delete-emptydir-data` 없이는 emptyDir 을 쓰는 Pod 에서 중단.
- drain 은 PodDisruptionBudget 을 지킨다. PDB 때문에 걸리면 기다리거나 PDB 를 확인. `--force` 로는 PDB 를 우회하지 못한다.
- 작업 후 습관적으로 `uncordon` 하면 지문 위반 ("그 상태로 둔다").
