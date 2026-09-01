# 풀이 — 0026 NetworkPolicy default-deny + DNS 허용

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata: {name: default-deny, namespace: secure}
spec:
  podSelector: {}
  policyTypes: [Ingress, Egress]
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata: {name: allow-dns, namespace: secure}
spec:
  podSelector: {}
  policyTypes: [Egress]
  egress:
    - ports:
        - {protocol: UDP, port: 53}
        - {protocol: TCP, port: 53}
```

```bash
k apply -f netpol.yaml
k -n secure exec worker -- nslookup kubernetes.default            # 성공
PIP=$(k -n public get po nginx -o jsonpath='{.status.podIP}')
k -n secure exec worker -- wget -qO- -T 3 http://$PIP             # timeout
```

`to` 를 생략하면 모든 목적지. 여러 정책은 합집합이라 `default-deny` 가 막아도 `allow-dns` 가 허용하면 통과한다.

## 함정

- `podSelector: {}` 는 "모든 Pod". 필드 자체를 빼면 스키마 오류.
- `default-deny` 에 `policyTypes: [Ingress, Egress]` 를 쓰지 않으면 Egress 는 차단되지 않는다 (`egress` 항목이 없으면 policyTypes 기본값은 Ingress 만).
- DNS 는 UDP 53 만 열면 대개 동작하지만, 응답이 크면 TCP 로 재시도하므로 둘 다 연다.
- `allow-dns` 에 `to: - namespaceSelector: {}` 를 붙여도 정답이지만 `to` 에 `podSelector` 만 쓰면 같은 네임스페이스로 제한되어 kube-dns 에 닿지 않는다.
