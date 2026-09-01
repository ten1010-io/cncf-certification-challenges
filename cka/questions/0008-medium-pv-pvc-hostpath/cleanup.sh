#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0008
ns_delete orders
$K delete pv pv-orders --ignore-not-found --wait=false >/dev/null 2>&1 || true
for n in "$CP_NODE" "$W1" "$W2"; do node_exec "$n" rm -rf /mnt/orders >/dev/null 2>&1 || true; done
