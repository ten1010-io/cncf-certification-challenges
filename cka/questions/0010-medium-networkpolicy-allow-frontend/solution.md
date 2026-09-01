# 풀이 — 0010 NetworkPolicy — frontend 만 허용

```bash
k get ns np-frontend --show-labels     # kubernetes.io/metadata.name=np-frontend (자동 라벨)
```

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: db-allow-web
  namespace: np-backend
spec:
  podSelector:
    matchLabels: {app: db}
  policyTypes: [Ingress]
  ingress:
    - from:
        - namespaceSelector:
            matchLabels: {kubernetes.io/metadata.name: np-frontend}
          podSelector:
            matchLabels: {app: web}
      ports:
        - {protocol: TCP, port: 80}
```

검증:

```bash
DB=$(k -n np-backend get po db -o jsonpath='{.status.podIP}')
k -n np-frontend exec web -- wget -qO- -T 3 http://$DB        # nginx HTML
k -n np-other exec intruder -- wget -qO- -T 3 http://$DB      # timeout
```

## 함정

- `namespaceSelector` 와 `podSelector` 는 **같은 from 항목**(하이픈 하나)에 둬야 AND 다. 하이픈을 두 개 쓰면 OR 가 되어 "np-frontend 의 모든 Pod" + "**모든 네임스페이스**의 app=web" 이 허용된다. `np-other/intruder` 가 `app=web` 이라 OR 로 쓰면 기능 채점에서 걸린다.
- `policyTypes` 에 `Egress` 를 넣고 egress 규칙을 안 쓰면 db 의 모든 egress 가 차단된다. 지문 "egress 는 제한하지 않는다" 위반.
- 네임스페이스는 이름이 아니라 라벨로 고른다. `kubernetes.io/metadata.name` 은 모든 ns 에 자동으로 붙는 라벨이다.
- `podSelector: {}` 는 "네임스페이스의 모든 Pod". `app=db` 만 대상으로 하라는 지문과 다르다.
