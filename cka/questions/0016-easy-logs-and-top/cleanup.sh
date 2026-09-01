#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0016
$K -n default delete po crasher --ignore-not-found --force --grace-period=0 >/dev/null 2>&1
ns_delete load
rm -f "$OUT/crasher.log" "$OUT/top-cpu.txt"
