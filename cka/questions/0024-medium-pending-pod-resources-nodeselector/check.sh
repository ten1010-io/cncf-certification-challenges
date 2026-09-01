#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0024
q_start 0024 6 "Pending Pod 해결 (리소스 요구 + nodeSelector)"
expect_eq "heavy readyReplicas 1" "1" "$(jp heavy deploy/heavy '{.status.readyReplicas}')"
expect_eq "memory request 128Mi" "128Mi" "$(jp heavy deploy/heavy '{.spec.template.spec.containers[0].resources.requests.memory}')"
expect_eq "cpu request 100m" "100m" "$(jp heavy deploy/heavy '{.spec.template.spec.containers[0].resources.requests.cpu}')"
expect_eq "memory limit 128Mi" "128Mi" "$(jp heavy deploy/heavy '{.spec.template.spec.containers[0].resources.limits.memory}')"
expect_eq "cpu limit 100m" "100m" "$(jp heavy deploy/heavy '{.spec.template.spec.containers[0].resources.limits.cpu}')"
expect_eq "nodeSelector disktype=ssd 유지" "ssd" "$(jp heavy deploy/heavy '{.spec.template.spec.nodeSelector.disktype}')"
expect_eq "노드 $W1 라벨 disktype=ssd" "ssd" "$(cjp "node/$W1" '{.metadata.labels.disktype}')"
expect_eq "pod 가 $W1 에서 Running" "$W1" "$($K -n heavy get po -l app=heavy --field-selector=status.phase=Running -o jsonpath='{.items[0].spec.nodeName}' 2>/dev/null)"
q_end; report
