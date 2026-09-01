# 풀이 — 0018 컨트롤플레인 장애 (kube-scheduler 매니페스트)

```bash
k -n sched-test get po                                # Pending
k -n sched-test describe po <pending-pod>             # Events 가 비어 있음 = 스케줄러가 Pod 를 본 적이 없다
k -n kube-system get po                               # kube-scheduler-cka-control-plane CrashLoopBackOff / Error
k -n kube-system logs kube-scheduler-cka-control-plane
#   ... open /etc/kubernetes/schedulerr.conf: no such file or directory
docker exec -it cka-control-plane bash
  ls /etc/kubernetes/                                 # scheduler.conf 는 있다. 매니페스트의 경로가 오타
  vi /etc/kubernetes/manifests/kube-scheduler.yaml    # --kubeconfig=/etc/kubernetes/schedulerr.conf -> scheduler.conf
  exit
k -n kube-system get po -w                            # kube-scheduler 재생성 후 Running
k -n sched-test get po                                # 2/2 Running
```

static pod 는 매니페스트를 저장하면 kubelet 이 즉시 재생성한다. 반영이 안 보이면 파일을 `/etc/kubernetes/manifests/` 밖으로 잠깐 옮겼다가 되돌린다.

## 함정

- Pending Pod 의 `describe` 에 `Insufficient cpu` 같은 이벤트가 **아무것도 없으면** 스케줄러 자체가 문제다. 노드 리소스·taint 를 뒤지지 말고 `kube-system` 을 본다.
- 컨트롤플레인 컴포넌트는 static pod 라 `kubectl edit` 로 고칠 수 없다. 노드의 `/etc/kubernetes/manifests/` 파일을 수정한다.
- `kubectl delete pod kube-scheduler-...` 는 mirror pod 만 지우고 매니페스트는 그대로라 다시 죽는다.
- Deployment 를 삭제·재생성하면 uid 가 바뀌어 지문 위반.
