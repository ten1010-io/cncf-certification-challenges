# 풀이 — 0030 etcd 스냅샷 + 복원 절차 작성

## 1. 스냅샷 저장

```bash
docker exec -it cka-control-plane bash
  grep -E "cert-file|key-file|trusted-ca-file|data-dir" /etc/kubernetes/manifests/etcd.yaml
  #   --cert-file=/etc/kubernetes/pki/etcd/server.crt
  #   --key-file=/etc/kubernetes/pki/etcd/server.key
  #   --trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
  #   --data-dir=/var/lib/etcd

  ETCDCTL_API=3 etcdctl snapshot save /opt/snapshot-02.db \
    --endpoints=https://127.0.0.1:2379 \
    --cacert=/etc/kubernetes/pki/etcd/ca.crt \
    --cert=/etc/kubernetes/pki/etcd/server.crt \
    --key=/etc/kubernetes/pki/etcd/server.key

  etcdutl snapshot status /opt/snapshot-02.db -w table
  exit
```

## 2. 복원 절차 (`/tmp/cncf-out/etcd-restore.sh`, 실행하지 않음)

```bash
#!/bin/bash
# kubeadm 클러스터 기준. control-plane 노드(cka-control-plane)에서 root 로 실행.
# 복원은 인증서가 필요 없다 — 스냅샷 파일을 새 디렉토리로 풀기만 한다.
etcdutl snapshot restore /opt/snapshot-02.db --data-dir=/var/lib/etcd-restore
# (구버전: ETCDCTL_API=3 etcdctl snapshot restore /opt/snapshot-02.db --data-dir=/var/lib/etcd-restore)

# etcd static pod 가 새 디렉토리를 쓰도록 매니페스트 수정.
# /etc/kubernetes/manifests/etcd.yaml 의
#   volumes: - hostPath: path: /var/lib/etcd   ->   path: /var/lib/etcd-restore
# (--data-dir 은 컨테이너 안 경로 /var/lib/etcd 그대로 두고 hostPath 만 바꾼다.
#  둘 다 바꾸는 방식이면 volumeMounts.mountPath 도 함께 수정.)
sed -i 's#path: /var/lib/etcd$#path: /var/lib/etcd-restore#' /etc/kubernetes/manifests/etcd.yaml

# kubelet 이 매니페스트 변경을 감지해 etcd 를 재시작한다. 1~2분 대기.
crictl ps | grep etcd
kubectl get po -n kube-system
```

## 함정

- 스냅샷 **저장**은 인증서 3개가 필수지만, **복원**은 로컬 파일 작업이라 `--endpoints`, 인증서가 필요 없다. 붙여도 무해하지만 `--data-dir` 을 빼먹으면 현재 디렉토리에 `default.etcd` 가 생긴다.
- `--data-dir` 을 기존 `/var/lib/etcd` 로 지정하면 "directory already exists" 로 실패한다. 반드시 새 디렉토리.
- 매니페스트에서 바꿀 곳은 `hostPath.path` 다. `--data-dir` 인자만 바꾸면 컨테이너 안 경로만 바뀌어 빈 디렉토리로 기동한다.
- 지문의 "실행하지 말 것"을 무시하고 실제로 매니페스트를 바꾸면 클러스터 API 가 잠시 끊기고 이후 문항 환경이 깨진다. 채점에서 매니페스트가 그대로인지 확인한다.
