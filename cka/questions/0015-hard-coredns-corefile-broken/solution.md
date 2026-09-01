# 풀이 — 0015 CoreDNS Corefile 복구 (DNS 장애)

```bash
k run t --rm -it --image=busybox:1.36 --restart=Never -- nslookup kubernetes.default.svc.cluster.local
#   ;; connection timed out / can't resolve   <- 재현
k -n kube-system get po -l k8s-app=kube-dns          # Running (Pod 는 정상)
k -n kube-system logs -l k8s-app=kube-dns            # 특별한 에러 없음
k -n kube-system get svc kube-dns                    # ClusterIP 정상, endpoints 있음
k -n kube-system get cm coredns -o yaml              # kubernetes cluster.locall  <- 오타
k -n kube-system edit cm coredns                     # cluster.locall -> cluster.local
k -n kube-system rollout restart deploy coredns      # reload 플러그인이 반영하지만 즉시 적용하려면 재시작
k run t --rm -it --image=busybox:1.36 --restart=Never -- nslookup kubernetes.default.svc.cluster.local
#   Name: kubernetes.default.svc.cluster.local  Address: 10.96.0.1
```

## 함정

- Pod 가 `Running` 이고 로그도 깨끗해서 Pod/Service 만 보면 원인이 안 나온다. DNS 장애는 **ConfigMap `coredns` 의 Corefile** 을 반드시 열어본다.
- `cluster.locall` 은 문법상 유효한 존 이름이라 CoreDNS 가 에러 없이 기동한다. 눈으로 오타를 찾아야 한다.
- Deployment 를 삭제·재생성하면 지문 위반. `edit cm` + `rollout restart` 로 해결.
- `nslookup` 결과에서 `Address` 줄이 서버 주소 1개만 나오면 실패, 2개 이상(서버 + 해석 결과)이면 성공.
