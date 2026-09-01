# 풀이 — 0002 Deployment + NodePort Service

```bash
k -n frontend create deploy web --image=nginx:1.25 --replicas=3 --port=80
k -n frontend get deploy web -o jsonpath='{.spec.template.metadata.labels}'   # create deploy 는 app=web 자동
k -n frontend expose deploy web --name=web-svc --port=80 --target-port=80 --type=NodePort
k -n frontend patch svc web-svc -p '{"spec":{"ports":[{"port":80,"targetPort":80,"nodePort":30080}]}}'
k -n frontend get svc web-svc          # 80:30080/TCP
k -n frontend get ep web-svc           # IP 3개
```

또는 `expose --dry-run=client -o yaml > svc.yaml` 뒤에 `nodePort: 30080` 한 줄을 추가하고 `k apply -f svc.yaml`.

검증 (클러스터 안에서):

```bash
NODE_IP=$(k get no cka-worker -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}')
k run t --rm -it --image=busybox:1.36 --restart=Never -- wget -qO- http://$NODE_IP:30080
```

## 함정

- `expose` 는 `nodePort` 를 지정하는 플래그가 없다. patch 나 YAML 편집이 한 단계 더 필요하다.
- `k run` 으로 Pod 를 만들면 Deployment 가 아니다. 지문의 리소스 종류를 그대로 만든다.
- `--port=80` 을 빼먹으면 containerPort 가 없다. 채점엔 안 걸려도 시험에선 지문 항목 하나가 빠진 것.
- Pod 라벨을 바꿨다면 Service selector 도 같아야 endpoints 가 생긴다. `k get ep` 로 확인.
