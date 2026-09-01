#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0014
node_exec "$W2" systemctl disable --now kubelet >/dev/null 2>&1 || true
echo "kubelet on $W2 stopped+disabled. 노드가 NotReady 로 바뀌기까지 ~40초."
cjp "node/$W2" '{.metadata.uid}' > "$STATE/node-uid"
