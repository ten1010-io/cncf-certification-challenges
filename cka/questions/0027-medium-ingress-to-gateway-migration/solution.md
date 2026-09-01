# 풀이 — 0027 Ingress → Gateway API 마이그레이션

```bash
k -n web get ing legacy -o yaml     # host, path, backend 확인
k api-resources | grep gateway      # Gateway API CRD 설치 확인
```

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata: {name: web-gw, namespace: web}
spec:
  gatewayClassName: nginx
  listeners:
    - {name: http, protocol: HTTP, port: 80}
---
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata: {name: app-route, namespace: web}
spec:
  parentRefs: [{name: web-gw}]
  hostnames: [app.local]
  rules:
    - matches: [{path: {type: PathPrefix, value: /v2}}]
      backendRefs: [{name: app-v2-svc, port: 80}]
    - matches: [{path: {type: PathPrefix, value: /}}]
      backendRefs: [{name: app-svc, port: 80}]
```

```bash
k apply -f gw.yaml
k -n web get gateway,httproute
k -n web delete ing legacy
```

## 함정

- Ingress `pathType: Prefix` 에 대응하는 HTTPRoute 값은 `PathPrefix` 다. `Prefix` 로 쓰면 스키마 오류.
- `backendRefs` 에 `port` 는 필수. Ingress 의 `service.port.number` 를 그대로 옮긴다.
- Gateway 컨트롤러가 없으면 `PROGRAMMED` 가 False/Unknown 이지만 리소스 spec 은 정상 생성된다. 채점은 spec 기준.
- Ingress 삭제를 잊으면 마지막 조건 미충족. 생성 → 확인 → 삭제 순서.
