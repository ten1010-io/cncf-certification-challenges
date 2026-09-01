# 풀이 — 0012 Gateway API — Gateway + HTTPRoute

`k create` 명령이 없다. 문서(kubernetes.io/docs/concepts/services-networking/gateway/)의 예제를 복사해 고친다.

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: shop-gw
  namespace: shop-gw
spec:
  gatewayClassName: nginx
  listeners:
    - name: http
      protocol: HTTP
      port: 80
---
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: shop-route
  namespace: shop-gw
spec:
  parentRefs:
    - name: shop-gw
  hostnames: ["shop.local"]
  rules:
    - matches:
        - path: {type: PathPrefix, value: /api}
      backendRefs:
        - {name: shop-api, port: 80}
    - matches:
        - path: {type: PathPrefix, value: /}
      backendRefs:
        - {name: shop-web, port: 80}
```

```bash
k apply -f gw.yaml
k -n shop-gw get gateway,httproute       # 컨트롤러가 없어 PROGRAMMED 는 비어 있어도 정상
k -n shop-gw get httproute shop-route -o yaml
```

## 함정

- `apiVersion` 은 `gateway.networking.k8s.io/v1`. `networking.k8s.io/v1`(Ingress 그룹)로 쓰면 CRD 를 찾지 못한다.
- `hostnames` 는 리스트다. Ingress 처럼 `host:` 단일 문자열로 쓰면 스키마 오류.
- `backendRefs` 의 `port` 는 Ingress 와 달리 정수 하나(`port: 80`). `port: {number: 80}` 는 Ingress 문법.
- 컨트롤러가 없어 `Accepted/Programmed` 상태가 안 잡히는 건 이 환경의 한계다. 스펙이 맞으면 통과.
