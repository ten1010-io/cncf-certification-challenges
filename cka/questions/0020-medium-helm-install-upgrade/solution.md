# 풀이 — 0020 Helm 설치와 업그레이드

```bash
k create ns helm-shop
helm install shop-web /tmp/cncf-out/charts/webapp-0.1.0.tgz -n helm-shop --set replicaCount=2
helm list -n helm-shop                                    # CHART webapp-0.1.0, STATUS deployed
k -n helm-shop get deploy                                 # shop-web-webapp 2/2

helm upgrade shop-web /tmp/cncf-out/charts/webapp-0.2.0.tgz -n helm-shop --set replicaCount=2
# 또는: helm upgrade shop-web /tmp/cncf-out/charts/webapp-0.2.0.tgz -n helm-shop --reuse-values
helm list -n helm-shop                                    # webapp-0.2.0, REVISION 2
helm history shop-web -n helm-shop > /tmp/cncf-out/helm-history.txt
cat /tmp/cncf-out/helm-history.txt                        # REVISION 1 webapp-0.1.0 superseded / 2 webapp-0.2.0 deployed
```

## 함정

- `helm upgrade` 에 `--set` 을 빼면 values 가 차트 기본값으로 리셋되어 `replicaCount=1` 이 된다. `--reuse-values` 또는 값을 다시 지정.
- 로컬 `.tgz` 경로를 그대로 차트 인자로 쓸 수 있다. `helm repo add` 가 필요하지 않다.
- `helm install` 에 `--create-namespace` 를 붙이면 네임스페이스 생성을 따로 하지 않아도 된다.
- Deployment 이름은 `<release>-<chart>` = `shop-web-webapp`. 릴리스 이름과 혼동하지 않는다.
