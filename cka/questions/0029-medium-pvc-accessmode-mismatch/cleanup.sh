#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0029
$K -n logs delete pod log-writer --ignore-not-found --force --grace-period=0 >/dev/null 2>&1 || true
$K -n logs delete pvc logs-pvc --ignore-not-found --wait=false >/dev/null 2>&1 || true
ns_delete logs
$K delete pv pv-logs --ignore-not-found --wait=false >/dev/null 2>&1 || true
