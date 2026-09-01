#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0030
node_exec "$CP_NODE" rm -f /opt/snapshot-02.db
rm -f "$OUT/etcd-restore.sh"
node_exec "$CP_NODE" which etcdctl >/dev/null 2>&1 || echo "WARN: 노드에 etcdctl 없음. common/setup/create-cluster.sh 의 etcdctl 설치 단계 확인. 대안: etcd Pod 안에서 kubectl exec"
