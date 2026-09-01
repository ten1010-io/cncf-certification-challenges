# 풀이 — 0019 노드 NotReady 복구 (kubelet kubeconfig 포트 오류)

```bash
k get no                                            # cka-worker2 NotReady
k describe no cka-worker2 | grep -A6 Conditions     # Kubelet stopped posting node status
k cluster-info                                      # https://127.0.0.1:xxxxx (호스트 포트). 클러스터 내부 포트는 6443
docker exec -it cka-worker2 bash
  systemctl status kubelet                          # active (running)  <- 정지는 아니다
  journalctl -u kubelet -n 50 --no-pager
  #   ... dial tcp <cp-ip>:6444: connect: connection refused
  grep server /etc/kubernetes/kubelet.conf          # server: https://cka-control-plane:6444
  sed -i 's/:6444/:6443/' /etc/kubernetes/kubelet.conf
  systemctl restart kubelet
  journalctl -u kubelet -n 20 --no-pager            # 에러 사라짐
  exit
k get no -w                                         # Ready
```

apiserver 포트 확인: control-plane 의 `/etc/kubernetes/manifests/kube-apiserver.yaml` 에서 `--secure-port` (기본 6443). 실제 시험도 6443.

## 함정

- kubelet 이 `active` 라서 `systemctl start` 로는 안 풀린다. **`journalctl -u kubelet`** 로 실제 에러를 읽어야 한다.
- kubelet 설정 파일이 둘이다. `/var/lib/kubelet/config.yaml` (KubeletConfiguration) 과 `/etc/kubernetes/kubelet.conf` (apiserver 접속용 kubeconfig). `connection refused` 는 후자.
- 수정 후 `systemctl restart kubelet` 을 빼먹으면 반영되지 않는다.
- `kubectl delete node` + 재조인은 지문 위반. uid 가 바뀌어 채점 실패.
