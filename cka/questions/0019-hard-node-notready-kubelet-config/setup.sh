#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0019
CONF=/etc/kubernetes/kubelet.conf
echo "==> $W2 kubelet.conf 백업 + apiserver 포트 오염 (6443 -> 6444)"
node_sh "$W2" "test -f $CONF.orig || cp $CONF $CONF.orig"
node_exec "$W2" sed -i 's/:6443/:6444/' "$CONF"
node_exec "$W2" systemctl restart kubelet
cjp "node/$W2" '{.metadata.uid}' > "$STATE/node-uid"
echo "kubelet 은 active 지만 apiserver 에 못 붙는다. 노드가 NotReady 로 바뀌기까지 ~40초."
