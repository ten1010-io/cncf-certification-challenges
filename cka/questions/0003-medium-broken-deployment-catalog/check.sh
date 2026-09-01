#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0003
q_start 0003 8 "고장난 Deployment 수정"
expect "deploy catalog 존재" $K -n catalog get deploy catalog
expect_eq "재생성 안 함 (uid 유지)" "$(cat "$STATE/catalog-uid" 2>/dev/null)" "$(jp catalog deploy/catalog '{.metadata.uid}')"
expect_eq "이미지 nginx:1.25" "nginx:1.25" "$(jp catalog deploy/catalog '{.spec.template.spec.containers[0].image}')"
expect_eq "replicas 2" "2" "$(jp catalog deploy/catalog '{.spec.replicas}')"
expect_eq "readyReplicas 2" "2" "$(jp catalog deploy/catalog '{.status.readyReplicas}')"
q_end; report
