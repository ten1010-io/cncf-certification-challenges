# kubectl 치트시트 (시험용)

## 생성 (imperative → YAML)

```bash
export do="--dry-run=client -o yaml"

k run nginx --image=nginx $do > pod.yaml
k run busybox --image=busybox --command -- sleep 3600
k run tmp --image=busybox --rm -it --restart=Never -- wget -qO- http://svc:80

k create deploy web --image=nginx --replicas=3 --port=80 $do > deploy.yaml
k create job pi --image=perl:5.34 -- perl -Mbignum=bpi -wle 'print bpi(2000)'
k create cronjob hello --image=busybox --schedule="*/5 * * * *" -- echo hello

k expose deploy web --port=80 --target-port=8080 --type=NodePort --name=web-svc
k create svc clusterip web --tcp=80:8080

k create cm app-cfg --from-literal=k=v --from-file=config.txt --from-env-file=.env
k create secret generic db --from-literal=password=pw
k create secret tls tls-secret --cert=tls.crt --key=tls.key

k create sa app-sa
k create role pod-reader --verb=get,list,watch --resource=pods
k create rolebinding rb --role=pod-reader --serviceaccount=default:app-sa
k create clusterrole node-reader --verb=get,list --resource=nodes
k create clusterrolebinding crb --clusterrole=node-reader --user=jane

k create ingress web --rule="host.com/path=svc:80" --class=nginx
k create pdb web-pdb --selector=app=web --min-available=1
k create quota q --hard=pods=10,cpu=4
k create ns dev
k create token app-sa
```

## 조회

```bash
k get all -A
k get po -o wide --show-labels
k get po -l app=web,tier!=db
k get po --field-selector=status.phase=Running
k get po -o jsonpath='{.items[*].metadata.name}'
k get po -o custom-columns=NAME:.metadata.name,IP:.status.podIP
k get po --sort-by=.metadata.creationTimestamp
k get no -o jsonpath='{.items[*].status.nodeInfo.kubeletVersion}'
k get events --sort-by=.lastTimestamp -A
k describe po X | grep -A10 Events
k explain deploy.spec.strategy --recursive
k api-resources --namespaced=true
k top po -A --sort-by=cpu
k top no
```

## 수정

```bash
k edit deploy web
k set image deploy/web nginx=nginx:1.25
k set env deploy/web KEY=VAL
k set resources deploy/web -c nginx --limits=cpu=200m,memory=256Mi --requests=cpu=100m,memory=128Mi
k set sa deploy/web app-sa
k scale deploy web --replicas=5
k autoscale deploy web --min=2 --max=10 --cpu-percent=80
k label po X env=prod --overwrite
k label no node01 disk=ssd
k annotate deploy web desc="x"
k taint no node01 key=value:NoSchedule
k taint no node01 key-               # 제거
k cordon node01 / k uncordon node01
k drain node01 --ignore-daemonsets --delete-emptydir-data --force
k patch deploy web -p '{"spec":{"replicas":3}}'
k replace --force -f pod.yaml        # 불변 필드 수정 시
```

## 롤아웃

```bash
k rollout status deploy/web
k rollout history deploy/web
k rollout history deploy/web --revision=2
k rollout undo deploy/web
k rollout undo deploy/web --to-revision=1
k rollout restart deploy/web
k rollout pause/resume deploy/web
```

## 디버깅

```bash
k logs X -c container --previous -f --tail=50
k logs -l app=web --all-containers
k exec -it X -c container -- sh
k debug X -it --image=busybox --target=container      # ephemeral container
k debug node/node01 -it --image=busybox               # 노드 디버그 (host fs: /host)
k port-forward svc/web 8080:80
k auth can-i create pods --as=jane -n dev
k auth can-i --list --as=system:serviceaccount:default:app-sa
k cp X:/path/file ./file
```

## 컨텍스트

```bash
k config get-contexts
k config use-context X
k config set-context --current --namespace=dev
k config view --minify
```

## 노드에서 자주 쓰는 명령

```bash
systemctl status kubelet; systemctl restart kubelet; journalctl -u kubelet -f
crictl ps -a; crictl logs <id>; crictl pods
ls /etc/kubernetes/manifests/          # static pod
cat /var/lib/kubelet/config.yaml       # kubelet config (staticPodPath, clusterDNS)
cat /etc/kubernetes/kubelet.conf       # kubelet kubeconfig
cat /etc/kubernetes/admin.conf
ls /etc/cni/net.d/                     # CNI 설정
ip a; ip route; iptables-save | grep <svc-ip>
```

## JSONPath / 출력

```bash
k get no -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.addresses[?(@.type=="InternalIP")].address}{"\n"}{end}'
k get po X -o jsonpath='{.spec.containers[*].image}'
k get pv --sort-by=.spec.capacity.storage
k get po -o yaml | grep -i image
```

## Helm / Kustomize

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami; helm repo update
helm search repo nginx --versions
helm install my-rel bitnami/nginx -n web --create-namespace --version 15.0.0 --set service.type=NodePort
helm upgrade my-rel bitnami/nginx --version 15.1.0 --reuse-values
helm rollback my-rel 1
helm list -A; helm history my-rel; helm uninstall my-rel
helm show values bitnami/nginx > values.yaml
helm template my-rel bitnami/nginx -f values.yaml > out.yaml

k apply -k ./overlays/prod
k kustomize ./overlays/prod
```
