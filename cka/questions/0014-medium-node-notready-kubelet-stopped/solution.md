# 풀이 — 0014 노드 NotReady 복구 (kubelet 정지)

```bash
k get no                                        # cka-worker2 NotReady
k describe no cka-worker2 | grep -A6 Conditions # Kubelet stopped posting node status
docker exec -it cka-worker2 bash
  systemctl status kubelet                      # inactive (dead); disabled
  systemctl enable --now kubelet                # start + enable 한 번에
  systemctl status kubelet                      # active (running)
  exit
k get no -w                                     # Ready
```

## 함정

- `systemctl start` 만 하면 재부팅 후 다시 죽는다. 지문의 "재부팅 후 유지" = `enable`.
- kubelet 이 `active` 인데 NotReady 면 다른 문제(설정 파일, 인증서, CNI, containerd). `journalctl -u kubelet -n 50` 로 넘어간다 → 문제 0019.
- `kubectl delete node` + 재조인은 지문 위반. uid 가 바뀌어 채점 실패.
