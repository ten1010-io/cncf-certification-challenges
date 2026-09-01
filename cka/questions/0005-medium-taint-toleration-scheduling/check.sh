#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0005
q_start 0005 6 "taint/toleration + nodeSelector 스케줄링"
expect_eq "노드 $W1 에 배치" "$W1" "$(jp batch pod/batch-runner '{.spec.nodeName}')"
expect_eq "Running" "Running" "$(jp batch pod/batch-runner '{.status.phase}')"
expect_contains "이미지 busybox:1.36" "busybox:1.36" "$(jp batch pod/batch-runner '{.spec.containers[0].image}')"
expect "nodeSelector 또는 nodeAffinity 존재" test -n "$(jp batch pod/batch-runner '{.spec.nodeSelector}{.spec.affinity.nodeAffinity}')"
expect_contains "toleration key dedicated" "dedicated" "$(jp batch pod/batch-runner '{.spec.tolerations[*].key}')"
q_end; report
