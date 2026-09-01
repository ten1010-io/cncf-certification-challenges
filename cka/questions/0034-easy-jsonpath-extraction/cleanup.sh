#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0034
$K delete pv pv-a pv-b pv-c --ignore-not-found --wait=false >/dev/null 2>&1 || true
rm -f "$OUT/node-ips.txt" "$OUT/pv-sorted.txt"
