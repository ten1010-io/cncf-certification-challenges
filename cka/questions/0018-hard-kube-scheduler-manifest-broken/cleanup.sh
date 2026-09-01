#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0018
node_exec "$CP_NODE" sed -i 's#schedulerr.conf#scheduler.conf#' /etc/kubernetes/manifests/kube-scheduler.yaml >/dev/null 2>&1 || true
ns_delete sched-test
rm -f "$STATE/pending-uid"
