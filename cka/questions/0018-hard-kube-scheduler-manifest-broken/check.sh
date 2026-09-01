#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0018
q_start 0018 8 "컨트롤플레인 장애 (kube-scheduler 매니페스트)"
SCHED=$($K -n kube-system get po -l component=kube-scheduler -o jsonpath='{.items[0].status.containerStatuses[0].ready}' 2>/dev/null)
expect_eq "kube-scheduler 컨테이너 Ready" "true" "$SCHED"
expect_eq "pending-app readyReplicas 2" "2" "$(jp sched-test deploy/pending-app '{.status.readyReplicas}')"
expect_eq "deployment 미변경 (uid 동일)" "$(cat "$STATE/pending-uid" 2>/dev/null)" "$(jp sched-test deploy/pending-app '{.metadata.uid}')"
BAD=$(node_sh "$CP_NODE" "grep -c schedulerr.conf /etc/kubernetes/manifests/kube-scheduler.yaml || true" 2>/dev/null | tr -d '\r\n ')
expect_eq "매니페스트에 schedulerr.conf 없음" "0" "${BAD:-1}"
q_end; report
