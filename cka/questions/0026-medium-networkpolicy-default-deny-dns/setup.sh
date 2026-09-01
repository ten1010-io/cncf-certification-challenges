#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0026
ns_ensure secure public
$K -n secure delete netpol default-deny allow-dns --ignore-not-found >/dev/null 2>&1 || true
$K -n secure run worker --image=busybox:1.36 --labels=app=worker --command -- sleep 36000 >/dev/null 2>&1 || true
$K -n public run nginx --image=nginx:1.25 --labels=app=nginx --port=80 >/dev/null 2>&1 || true
wait_ready_pod secure worker
wait_ready_pod public nginx
