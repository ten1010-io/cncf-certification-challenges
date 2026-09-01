# 풀이 — 0031 kubeadm control-plane 업그레이드 절차 작성

문서 "Upgrading kubeadm clusters" 의 순서 그대로. `/tmp/cncf-out/upgrade-cp.sh`:

```bash
#!/bin/bash
# control-plane 노드 cka-control-plane 을 v1.34.x -> v1.35.0 으로 업그레이드 (Ubuntu/apt). 실행하지 않음.

# 0. 워크로드 내보내기 (로컬 kubectl)
kubectl drain cka-control-plane --ignore-daemonsets

# 1. 노드 진입 (시험: ssh cp01 / 여기: docker exec -it cka-control-plane bash). 노드 안은 root.
# 1-1. 패키지 저장소를 새 마이너 버전으로
sed -i 's#v1.34#v1.35#' /etc/apt/sources.list.d/kubernetes.list
apt-get update

# 1-2. kubeadm 먼저 업그레이드
apt-mark unhold kubeadm
apt-get install -y kubeadm='1.35.0-*'
apt-mark hold kubeadm
kubeadm version

# 1-3. 업그레이드 계획 확인 후 적용 (첫 control-plane 은 apply, 추가 control-plane 은 upgrade node)
kubeadm upgrade plan
kubeadm upgrade apply v1.35.0 -y

# 1-4. kubelet / kubectl 업그레이드 후 재시작
apt-mark unhold kubelet kubectl
apt-get install -y kubelet='1.35.0-*' kubectl='1.35.0-*'
apt-mark hold kubelet kubectl
systemctl daemon-reload
systemctl restart kubelet
exit

# 2. 노드 복귀 (로컬 kubectl)
kubectl uncordon cka-control-plane
kubectl get nodes
```

## 함정

- `kubeadm` 을 먼저 올리고 `kubeadm upgrade apply`, **그 다음** kubelet 을 올린다. kubelet 을 먼저 올리면 버전 스큐 정책 위반.
- 마이너 버전이 바뀌면 `/etc/apt/sources.list.d/kubernetes.list` 의 저장소 경로(`v1.34` → `v1.35`)를 바꿔야 새 패키지가 보인다. 이걸 빼먹으면 `apt-get install kubeadm=1.35.0-*` 이 패키지를 못 찾는다.
- 워커 노드는 `kubeadm upgrade node` 지만 control-plane 첫 노드는 `kubeadm upgrade apply <버전>`.
- drain 만 하고 uncordon 을 잊으면 노드가 `SchedulingDisabled` 로 남는다. 채점 키워드에 포함.
