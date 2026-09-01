# 풀이 — 0017 Service 연결 불가 (selector, targetPort 불일치)

```bash
k -n checkout get ep checkout-svc                         # <none>  <- selector 가 Pod 를 못 잡음
k -n checkout describe svc checkout-svc                   # Selector: app=checkout-v1, TargetPort: 8080/TCP
k -n checkout get po -l app=checkout -o wide --show-labels  # 라벨 app=checkout, 컨테이너 포트 80
k -n checkout edit svc checkout-svc
#   spec.selector:  app: checkout
#   ports[0].targetPort: 80
k -n checkout get ep checkout-svc                         # 10.244.x.x:80,10.244.y.y:80
k run t --rm -it --image=busybox:1.36 --restart=Never -- wget -qO- -T 3 http://checkout-svc.checkout:80
```

패치로도 가능:

```bash
k -n checkout patch svc checkout-svc -p '{"spec":{"selector":{"app":"checkout"},"ports":[{"port":80,"targetPort":80,"protocol":"TCP"}]}}'
```

## 함정

- 원인이 **두 개**다. selector 만 고치면 endpoints 는 생기지만 `targetPort: 8080` 이라 여전히 접속 실패. endpoints 확인 후 반드시 curl/wget 으로 기능 테스트.
- Deployment 의 라벨을 Service 에 맞춰 바꾸면 지문 위반(uid 는 안 바뀌어도 "수정 금지"). 항상 Service 쪽을 고친다.
- `k get ep` 가 `<none>` 이면 selector 문제, IP 는 있는데 응답이 없으면 targetPort/NetworkPolicy 문제로 갈라서 본다.
