#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0019
node_exec "$W2" sed -i 's/:6444/:6443/' /etc/kubernetes/kubelet.conf >/dev/null 2>&1 || true
node_exec "$W2" systemctl restart kubelet >/dev/null 2>&1 || true
rm -f "$STATE/node-uid"
