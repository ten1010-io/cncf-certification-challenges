# 풀이 — 0011 Ingress 경로 라우팅

```bash
k -n shop create ingress shop-ingress --class=nginx \
  --rule="shop.local/api*=shop-api:80" \
  --rule="shop.local/*=shop-web:80"
k -n shop get ing shop-ingress -o yaml     # pathType: Prefix 두 개, host shop.local
```

YAML 로 쓰면:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: shop-ingress
  namespace: shop
spec:
  ingressClassName: nginx
  rules:
    - host: shop.local
      http:
        paths:
          - path: /api
            pathType: Prefix
            backend:
              service: {name: shop-api, port: {number: 80}}
          - path: /
            pathType: Prefix
            backend:
              service: {name: shop-web, port: {number: 80}}
```

검증 (ingress-nginx 가 있는 이 환경에서):

```bash
ING=$(k -n ingress-nginx get svc ingress-nginx-controller -o jsonpath='{.spec.clusterIP}')
k run t --rm -it --image=busybox:1.36 --restart=Never -- wget -qO- --header "Host: shop.local" http://$ING/
```

## 함정

- `create ingress --rule` 에서 경로 끝의 `*` 가 `Prefix`, 없으면 `Exact`. `/api=shop-api:80` 으로 쓰면 pathType Exact 로 오답.
- `--class=nginx` 를 빼면 `ingressClassName` 이 비어 컨트롤러가 무시한다.
- 옛 문법 `kubernetes.io/ingress.class` 어노테이션은 채점 대상이 아니다. `spec.ingressClassName` 을 쓴다.
- `backend.service.port` 는 `number: 80` 또는 `name:`. `port: 80` 처럼 바로 쓰면 스키마 오류.
