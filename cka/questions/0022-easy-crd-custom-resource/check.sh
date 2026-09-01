#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0022
q_start 0022 5 "CRD 조회와 Custom Resource 생성"
expect_contains "crds.txt 에 shirts.stable.example.com" "shirts.stable.example.com" "$(cat "$OUT/crds.txt" 2>/dev/null)"
expect_eq "crds.txt 는 한 줄 (이름만)" "1" "$(grep -c . "$OUT/crds.txt" 2>/dev/null)"
expect_eq "blue-shirt spec.color blue" "blue" "$(jp default shirt/blue-shirt '{.spec.color}')"
expect_eq "blue-shirt spec.size M" "M" "$(jp default shirt/blue-shirt '{.spec.size}')"
q_end; report
