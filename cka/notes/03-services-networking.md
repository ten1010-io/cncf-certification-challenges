# 03. Services & Networking (20%)

## 커리큘럼 항목

- Pod 간 연결성(클러스터 네트워크 모델)
- NetworkPolicy 정의/적용
- ClusterIP, NodePort, LoadBalancer
- Gateway API로 Ingress 트래픽 처리 (신규)
- Ingress 컨트롤러/리소스
- CoreDNS

---

## 1. 네트워크 모델

- 모든 Pod는 NAT 없이 서로 통신. Pod IP는 클러스터 전체에서 유일. CNI 플러그인이 구현.
- 노드 ↔ Pod 통신 가능. Service는 kube-proxy(iptables/ipvs)가 가상 IP → Pod IP DNAT.
- Pod CIDR: `k cluster-info dump | grep -m1 cluster-cidr` 또는 `k get no -o jsonpath='{.items[*].spec.podCIDR}'`.
- Service CIDR: `kube-apiserver --service-cluster-ip-range`.

## 2. Service

| 타입 | 접근 | 비고 |
|---|---|---|
| ClusterIP | 클러스터 내부 | 기본. `clusterIP: None` = headless(DNS가 Pod IP 직접 반환) |
| NodePort | `<NodeIP>:30000-32767` | ClusterIP 포함. `nodePort` 지정 가능 |
| LoadBalancer | 외부 LB | 클라우드/MetalLB. NodePort 포함 |
| ExternalName | DNS CNAME | selector 없음 |

```bash
k expose deploy web --port=80 --target-port=8080 --type=NodePort --name=web-svc
k expose pod nginx --port=80 --name=nginx-svc
k create svc nodeport web --tcp=80:8080 --node-port=30080
k get ep web-svc            # endpoints 비어있으면 selector/포트 불일치 또는 readiness 실패
k get endpointslices -l kubernetes.io/service-name=web-svc
```

```yaml
apiVersion: v1
kind: Service
metadata: {name: web-svc}
spec:
  type: NodePort
  selector: {app: web}
  ports:
    - name: http
      port: 80            # 서비스 포트
      targetPort: 8080    # 컨테이너 포트 (이름도 가능)
      nodePort: 30080
      protocol: TCP
  sessionAffinity: ClientIP
```

Endpoint 비는 3대 원인: selector ≠ Pod 라벨, targetPort ≠ containerPort, Pod readiness 실패.

## 3. DNS (CoreDNS)

- Service: `<svc>.<ns>.svc.cluster.local`. 같은 ns면 `<svc>`만.
- Pod: `<ip-dash>.<ns>.pod.cluster.local` (거의 안 씀). headless svc + StatefulSet: `<pod>.<svc>.<ns>.svc.cluster.local`.
- Pod의 `/etc/resolv.conf`: `nameserver 10.96.0.10`(kube-dns svc), `search <ns>.svc.cluster.local svc.cluster.local cluster.local`.
- CoreDNS 설정: `k -n kube-system get cm coredns -o yaml` (Corefile). 수정 후 `k -n kube-system rollout restart deploy coredns`.

```
.:53 {
    errors
    health
    kubernetes cluster.local in-addr.arpa ip6.arpa { pods insecure; fallthrough in-addr.arpa ip6.arpa }
    forward . /etc/resolv.conf          # 업스트림. 8.8.8.8 로 바꾸는 문제 나옴
    cache 30
    loop
    reload
}
```

디버그:

```bash
k run dns-test --image=busybox:1.28 --rm -it --restart=Never -- nslookup web-svc.default.svc.cluster.local
k -n kube-system logs -l k8s-app=kube-dns
k -n kube-system get svc kube-dns
cat /var/lib/kubelet/config.yaml | grep clusterDNS     # 노드에서
```

Pod `dnsPolicy`: ClusterFirst(기본) / Default(노드 resolv) / None(dnsConfig 수동) / ClusterFirstWithHostNet.

## 4. NetworkPolicy

- CNI가 지원해야 동작(Calico, Cilium O / Flannel X).
- 기본: 정책 없으면 전부 허용. Pod에 정책 하나라도 선택되면 그 방향(policyTypes)은 **deny-by-default**.
- `podSelector: {}` = ns 내 모든 Pod. `ingress: []` 또는 생략 + policyTypes 명시 = 전부 차단.
- from/to 항목: `podSelector`, `namespaceSelector`, `ipBlock`. **같은 항목 안에 podSelector+namespaceSelector = AND**, 별도 항목(`-`)이면 OR.

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata: {name: allow-frontend, namespace: backend}
spec:
  podSelector: {matchLabels: {app: api}}
  policyTypes: [Ingress, Egress]
  ingress:
    - from:
        - namespaceSelector: {matchLabels: {kubernetes.io/metadata.name: frontend}}
          podSelector: {matchLabels: {app: web}}        # AND: frontend ns의 app=web
        - ipBlock: {cidr: 10.0.0.0/8, except: [10.0.1.0/24]}
      ports:
        - {protocol: TCP, port: 8080}
  egress:
    - to:
        - podSelector: {matchLabels: {app: db}}
      ports: [{protocol: TCP, port: 5432}]
    - to: []                                            # DNS 허용
      ports: [{protocol: UDP, port: 53}]
```

자주 나오는 정책:

```yaml
# default deny all (ingress+egress)
spec: {podSelector: {}, policyTypes: [Ingress, Egress]}
# default deny ingress only
spec: {podSelector: {}, policyTypes: [Ingress]}
# allow all ingress
spec: {podSelector: {}, ingress: [{}], policyTypes: [Ingress]}
```

ns 라벨: `kubernetes.io/metadata.name=<ns>` 자동 부여. 없으면 `k label ns X team=a`.

시험 유형: "ns A의 Pod만 ns B의 app=db 5432 접근 허용, 나머지 차단". 문제에 **기존 정책 건드리지 말라** 조건 흔함.

## 5. Ingress

```bash
k create ingress web --class=nginx --rule="shop.com/api*=api-svc:80" --rule="shop.com/=web-svc:80"
k get ingressclass
k describe ing web
```

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  tls:
    - hosts: [shop.com]
      secretName: shop-tls
  rules:
    - host: shop.com
      http:
        paths:
          - path: /api
            pathType: Prefix          # Prefix | Exact | ImplementationSpecific
            backend:
              service: {name: api-svc, port: {number: 80}}
          - path: /
            pathType: Prefix
            backend:
              service: {name: web-svc, port: {name: http}}
  defaultBackend:
    service: {name: default-svc, port: {number: 80}}
```

- Ingress 리소스만 만들면 동작 안 함. Ingress Controller(nginx 등) 배포 + IngressClass 필요. 시험은 컨트롤러 이미 설치된 상태에서 리소스 작성. `k get ingressclass`로 이름 확인 필수.
- 테스트: `curl -H "Host: shop.com" http://<node-ip>:<controller-nodeport>/api`.

## 6. Gateway API (1.35 커리큘럼 신규)

역할 분리: GatewayClass(인프라 제공자) → Gateway(클러스터 운영자, 리스너) → HTTPRoute(앱 개발자, 라우팅).

```bash
k get gatewayclass
k get gateway -A
k get httproute -A
k describe gateway web-gw       # Listeners, Addresses, Conditions
```

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata: {name: web-gw, namespace: default}
spec:
  gatewayClassName: nginx            # k get gatewayclass 로 확인
  listeners:
    - name: http
      protocol: HTTP
      port: 80
      allowedRoutes:
        namespaces: {from: Same}     # Same | All | Selector
    - name: https
      protocol: HTTPS
      port: 443
      tls:
        mode: Terminate
        certificateRefs: [{kind: Secret, name: web-tls}]
---
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata: {name: web-route, namespace: default}
spec:
  parentRefs:
    - name: web-gw
      sectionName: http              # 특정 listener에만 붙일 때
  hostnames: [shop.com]
  rules:
    - matches:
        - path: {type: PathPrefix, value: /api}     # Exact | PathPrefix | RegularExpression
          headers: [{name: x-version, value: v2}]
      backendRefs:
        - {name: api-v2, port: 80, weight: 90}
        - {name: api-v1, port: 80, weight: 10}     # 가중치 카나리
      filters:
        - type: RequestHeaderModifier
          requestHeaderModifier: {add: [{name: x-gw, value: "1"}]}
    - matches: [{path: {type: PathPrefix, value: /}}]
      backendRefs: [{name: web-svc, port: 80}]
```

시험 유형: "기존 Ingress를 Gateway+HTTPRoute로 마이그레이션", "HTTPRoute에 TLS listener 추가", "특정 경로를 다른 svc로 라우팅", "트래픽 80/20 분배". 다른 ns의 Service 참조 시 ReferenceGrant 필요.

## 7. kube-proxy

- DaemonSet `kube-proxy`. 모드: iptables(기본) / ipvs / nftables.
- 설정: `k -n kube-system get cm kube-proxy -o yaml`.
- 죽으면 신규 Service 접근 불가(기존 iptables 규칙은 남음). 로그: `k -n kube-system logs -l k8s-app=kube-proxy`.

## 8. 네트워크 디버깅 흐름

```
Pod → Service 안 됨?
1. k get ep <svc>                    endpoints 있나
2. k get po -l <selector> -o wide    Pod Running & Ready 인가
3. k describe svc                    targetPort ≠ containerPort?
4. k run tmp --image=nicolaka/netshoot --rm -it -- curl <pod-ip>:<port>   Pod 직접 접근 되나
5. nslookup <svc>                    DNS 되나 → CoreDNS 확인
6. k get netpol -A                   NetworkPolicy가 막나
7. kube-proxy 로그, CNI Pod 상태
```

## 시험 빈출 정리

1. Deployment expose → NodePort 특정 포트
2. NetworkPolicy: 특정 ns/Pod에서만 접근 허용 + DNS egress
3. Ingress 리소스 작성(host, path, backend, ingressClassName)
4. Gateway + HTTPRoute 작성 또는 Ingress → Gateway API 전환
5. CoreDNS upstream 변경, DNS 안 되는 Pod 디버깅
6. Service endpoint 없는 원인(selector/port) 수정
7. `k get svc/ep/no -o wide` 결과를 파일로 저장
