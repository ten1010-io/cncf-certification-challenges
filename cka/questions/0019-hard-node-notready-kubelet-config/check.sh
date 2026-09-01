#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0019
q_start 0019 8 "노드 NotReady 복구 (kubelet kubeconfig 포트 오류)"
expect_eq "노드 $W2 Ready" "True" "$(cjp "node/$W2" '{.status.conditions[?(@.type=="Ready")].status}')"
GOOD=$(node_sh "$W2" "grep -c ':6443' /etc/kubernetes/kubelet.conf || true" 2>/dev/null | tr -d '\r\n ')
expect_ge "kubelet.conf 에 apiserver 포트 6443" 1 "${GOOD:-0}"
BAD=$(node_sh "$W2" "grep -c ':6444' /etc/kubernetes/kubelet.conf || true" 2>/dev/null | tr -d '\r\n ')
expect_eq "kubelet.conf 에 6444 없음" "0" "${BAD:-1}"
expect_eq "노드 재조인 안 함 (uid 유지)" "$(cat "$STATE/node-uid" 2>/dev/null)" "$(cjp "node/$W2" '{.metadata.uid}')"
q_end; report
