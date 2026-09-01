#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0030
node_exec "$CP_NODE" rm -f /opt/snapshot-02.db 2>/dev/null
rm -f "$OUT/etcd-restore.sh"
