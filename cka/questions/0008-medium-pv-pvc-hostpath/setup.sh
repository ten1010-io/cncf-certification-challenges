#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0008
ns_ensure orders
for n in "$CP_NODE" "$W1" "$W2"; do node_exec "$n" mkdir -p /mnt/orders; done
