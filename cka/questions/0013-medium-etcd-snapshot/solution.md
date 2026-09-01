# 풀이 — 0013 etcd 스냅샷 백업

```bash
docker exec -it cka-control-plane bash
  grep -E "cert-file|key-file|trusted-ca-file|listen-client-urls" /etc/kubernetes/manifests/etcd.yaml
  #   --cert-file=/etc/kubernetes/pki/etcd/server.crt
  #   --key-file=/etc/kubernetes/pki/etcd/server.key
  #   --trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
  #   --listen-client-urls=https://127.0.0.1:2379,https://<node-ip>:2379

  ETCDCTL_API=3 etcdctl snapshot save /opt/snapshot-01.db \
    --endpoints=https://127.0.0.1:2379 \
    --cacert=/etc/kubernetes/pki/etcd/ca.crt \
    --cert=/etc/kubernetes/pki/etcd/server.crt \
    --key=/etc/kubernetes/pki/etcd/server.key

  etcdutl snapshot status /opt/snapshot-01.db -w table
  exit
docker exec cka-control-plane etcdutl snapshot status /opt/snapshot-01.db -w table > /tmp/cncf-out/etcd-status.txt
```

`etcdutl` 없으면 `ETCDCTL_API=3 etcdctl snapshot status ...` (deprecated 경고만 나오고 동작).

## 노드에 etcdctl 이 없을 때

etcd Pod 안에서 실행. 단, Pod 는 `/opt` 가 마운트되어 있지 않아 `/var/lib/etcd/` 아래에 저장해야 한다.

```bash
k -n kube-system exec etcd-cka-control-plane -- sh -c 'ETCDCTL_API=3 etcdctl snapshot save /var/lib/etcd/snapshot-01.db \
  --endpoints=https://127.0.0.1:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key'
docker exec cka-control-plane mv /var/lib/etcd/snapshot-01.db /opt/snapshot-01.db
```

## 함정

- `--cacert` 빠지면 `x509: certificate signed by unknown authority`. 세 인증서 모두 필수.
- 문서 "Operating etcd clusters for Kubernetes" 에 명령 그대로 있음. 경로만 매니페스트에서 확인.
- 시험은 저장 경로가 채점 기준. `/opt/snapshot-01.db` 오타 = 0점.
