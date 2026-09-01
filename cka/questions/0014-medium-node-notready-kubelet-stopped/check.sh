#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0014
q_start 0014 8 "노드 NotReady 복구 (kubelet 정지)"
expect_eq "노드 $W2 Ready" "True" "$(cjp "node/$W2" '{.status.conditions[?(@.type=="Ready")].status}')"
ACTIVE=$(node_exec "$W2" systemctl is-active kubelet 2>/dev/null | tr -d '\r\n')
expect_eq "kubelet active" "active" "$ACTIVE"
EN=$(node_exec "$W2" systemctl is-enabled kubelet 2>/dev/null | tr -d '\r\n')
expect_eq "kubelet enabled (재부팅 유지)" "enabled" "$EN"
expect_eq "노드 재조인 안 함 (uid 유지)" "$(cat "$STATE/node-uid" 2>/dev/null)" "$(cjp "node/$W2" '{.metadata.uid}')"
q_end; report
