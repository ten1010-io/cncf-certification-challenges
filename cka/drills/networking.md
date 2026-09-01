# Drills — Services & Networking

준비:
```bash
kubectl create ns drill-n --dry-run=client -o yaml | kubectl apply -f -
kubectl -n drill-n create deploy web --image=nginx:1.25 --port=80 --replicas=2
kubectl -n drill-n run client --image=busybox:1.36 --labels=role=client --command -- sleep 36000
kubectl -n default run outsider --image=busybox:1.36 --command -- sleep 36000
```
정리: `kubectl delete ns drill-n; kubectl delete po outsider`

---

### N1. `web` 을 ClusterIP `web-svc`(port 8080 → 80) 로 노출. `client` 에서 `wget -qO- web-svc:8080` 성공 확인.
<details><summary>정답</summary>

```bash
k -n drill-n expose deploy web --name=web-svc --port=8080 --target-port=80
k -n drill-n exec client -- wget -qO- -T 3 web-svc:8080
```
</details>

### N2. `web` 을 NodePort 31000 으로 노출하는 `web-np` 생성.
<details><summary>정답</summary>

```bash
k -n drill-n expose deploy web --name=web-np --port=80 --type=NodePort $do > np.yaml
# ports[0].nodePort: 31000
k apply -f np.yaml
```
</details>

### N3. `web-svc` 의 endpoints 가 비게 만드는 방법 3가지를 말하고, 각각 어떻게 확인하는지.
<details><summary>정답</summary>

1. selector ≠ Pod 라벨 → `k describe svc` Selector vs `k get po --show-labels`
2. targetPort ≠ containerPort → `k describe svc` TargetPort vs `k get po -o yaml | grep containerPort` (endpoint 는 생기지만 연결 실패)
3. Pod not Ready(readiness 실패) → `k get po` READY 0/1, `k get ep` 비어있음
</details>

### N4. 다른 ns(`default`) 의 `outsider` 에서 `web-svc` 를 FQDN 으로 호출.
<details><summary>정답</summary>

```bash
k exec outsider -- wget -qO- -T 3 web-svc.drill-n.svc.cluster.local:8080
k exec outsider -- cat /etc/resolv.conf    # search default.svc.cluster.local svc.cluster.local cluster.local
```
</details>

### N5. NetworkPolicy `web-only-client`: ns drill-n 의 `app=web` Pod 에 대해 `role=client` Pod 에서 오는 TCP 80 만 허용. `outsider` 에서는 차단됨을 확인.
<details><summary>정답</summary>

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata: {name: web-only-client, namespace: drill-n}
spec:
  podSelector: {matchLabels: {app: web}}
  policyTypes: [Ingress]
  ingress:
    - from:
        - podSelector: {matchLabels: {role: client}}
      ports: [{protocol: TCP, port: 80}]
```
```bash
WEB=$(k -n drill-n get po -l app=web -o jsonpath='{.items[0].status.podIP}')
k -n drill-n exec client -- wget -qO- -T 3 $WEB        # OK
k exec outsider -- wget -qO- -T 3 $WEB                  # timeout
```
같은 ns 의 podSelector 만 쓰면 다른 ns 는 전부 차단.
</details>

### N6. ns `drill-n` 에 egress default-deny 를 걸되 DNS 와 `app=web` 으로의 80 은 허용.
<details><summary>정답</summary>

```yaml
spec:
  podSelector: {}
  policyTypes: [Egress]
  egress:
    - to: [{podSelector: {matchLabels: {app: web}}}]
      ports: [{protocol: TCP, port: 80}]
    - ports: [{protocol: UDP, port: 53}, {protocol: TCP, port: 53}]
```
</details>

### N7. Ingress `web-ing`: class `nginx`, host `drill.local`, `/` → web-svc:8080, `/static` (Exact) → web-svc:8080. 명령형으로 생성.
<details><summary>정답</summary>

```bash
k -n drill-n create ingress web-ing --class=nginx \
  --rule="drill.local/*=web-svc:8080" \
  --rule="drill.local/static=web-svc:8080"
# '*' 없음 = Exact
```
</details>

### N8. N7 과 동일한 라우팅을 Gateway `drill-gw`(class nginx, http/80) + HTTPRoute `web-route` 로 작성.
<details><summary>정답</summary>

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata: {name: drill-gw, namespace: drill-n}
spec:
  gatewayClassName: nginx
  listeners: [{name: http, protocol: HTTP, port: 80}]
---
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata: {name: web-route, namespace: drill-n}
spec:
  parentRefs: [{name: drill-gw}]
  hostnames: [drill.local]
  rules:
    - matches: [{path: {type: Exact, value: /static}}]
      backendRefs: [{name: web-svc, port: 8080}]
    - matches: [{path: {type: PathPrefix, value: /}}]
      backendRefs: [{name: web-svc, port: 8080}]
```
</details>

### N9. HTTPRoute 로 `web-svc` 90%, `web-v2-svc` 10% 가중치 분배.
<details><summary>정답</summary>

```yaml
backendRefs:
  - {name: web-svc, port: 8080, weight: 90}
  - {name: web-v2-svc, port: 8080, weight: 10}
```
</details>

### N10. CoreDNS 가 외부 도메인을 `1.1.1.1` 로 포워딩하게 변경.
<details><summary>정답</summary>

```bash
k -n kube-system edit cm coredns     # forward . /etc/resolv.conf  ->  forward . 1.1.1.1
k -n kube-system rollout restart deploy coredns
```
</details>

### N11. `client` Pod 에서 `web-svc` 이름 해석이 실패할 때 확인 순서 5단계.
<details><summary>정답</summary>

1. `k exec client -- cat /etc/resolv.conf` nameserver = kube-dns ClusterIP?
2. `k -n kube-system get svc kube-dns` 존재/IP 일치?
3. `k -n kube-system get po -l k8s-app=kube-dns` Running? 로그 에러?
4. `k -n kube-system get cm coredns -o yaml` Corefile 오타?
5. NetworkPolicy 가 egress 53 차단? `k get netpol -A`
</details>

### N12. Service 의 ClusterIP 를 `None` 으로 만들면 무슨 일이 생기고 어디에 쓰나.
<details><summary>정답</summary>

Headless. DNS 가 VIP 대신 Pod IP 들의 A 레코드 반환. StatefulSet 의 `<pod>.<svc>` 고정 이름, 클라이언트 측 로드밸런싱에 사용.
</details>
