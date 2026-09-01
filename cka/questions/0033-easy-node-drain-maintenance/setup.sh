#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0033
$K uncordon "$W2" >/dev/null 2>&1 || true
ns_ensure maint
$K -n maint create deploy drain-victim --image=nginx:1.25 --replicas=2 --dry-run=client -o yaml | $K apply -f - >/dev/null
wait_deploy maint drain-victim
