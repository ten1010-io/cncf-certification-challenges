#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0016
q_start 0016 6 "로그와 리소스 모니터링"
expect "crasher.log 존재 & 비어있지 않음" test -s "$OUT/crasher.log"
expect_contains "crasher.log 에 FATAL" "FATAL" "$(cat "$OUT/crasher.log" 2>/dev/null)"
expect "top-cpu.txt 존재 & 비어있지 않음" test -s "$OUT/top-cpu.txt"
expect_eq "top-cpu.txt == busy (이름만)" "busy" "$(tr -d '[:space:]' < "$OUT/top-cpu.txt" 2>/dev/null)"
q_end; report
