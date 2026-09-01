#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0004
q_start 0004 5 "롤링 업데이트와 롤백"
expect_eq "재생성 안 함 (uid 유지)" "$(cat "$STATE/api-uid" 2>/dev/null)" "$(jp api deploy/api '{.metadata.uid}')"
expect_eq "최종 이미지 nginx:1.24" "nginx:1.24" "$(jp api deploy/api '{.spec.template.spec.containers[0].image}')"
expect_eq "readyReplicas 2" "2" "$(jp api deploy/api '{.status.readyReplicas}')"
REV=$(jp api deploy/api '{.metadata.annotations.deployment\.kubernetes\.io/revision}')
expect_ge "revision >= 3 (업데이트 + 롤백)" 3 "$REV"
RS_IMAGES=$($K -n api get rs -l app=api -o jsonpath='{.items[*].spec.template.spec.containers[0].image}' 2>/dev/null)
expect_contains "히스토리에 nginx:1.25 ReplicaSet 남아 있음" "nginx:1.25" "$RS_IMAGES"
q_end; report
