#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0006
q_start 0006 4 "DaemonSet 전 노드 배치"
NODES=$($K get no --no-headers 2>/dev/null | wc -l | tr -d ' ')
expect "ds node-agent 존재" $K -n monitoring get ds node-agent
expect_eq "desired == 노드 수 ($NODES)" "$NODES" "$(jp monitoring ds/node-agent '{.status.desiredNumberScheduled}')"
expect_eq "ready == 노드 수 ($NODES)" "$NODES" "$(jp monitoring ds/node-agent '{.status.numberReady}')"
expect_contains "이미지 busybox:1.36" "busybox:1.36" "$(jp monitoring ds/node-agent '{.spec.template.spec.containers[0].image}')"
expect_eq "Pod 라벨 app=node-agent" "node-agent" "$(jp monitoring ds/node-agent '{.spec.template.metadata.labels.app}')"
CP_POD=$($K -n monitoring get po -l app=node-agent --field-selector "spec.nodeName=$CP_NODE,status.phase=Running" -o name 2>/dev/null | head -1)
expect "control-plane 노드에 Running Pod 존재" test -n "$CP_POD"
q_end; report
