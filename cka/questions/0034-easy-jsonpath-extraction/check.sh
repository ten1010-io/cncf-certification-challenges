#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0034
q_start 0034 5 "jsonpath / sort-by 정보 추출"
F="$OUT/node-ips.txt"
expect "node-ips.txt 존재 & 비어있지 않음" test -s "$F"
NODES=$($K get no --no-headers 2>/dev/null | wc -l | tr -d ' ')
expect_eq "node-ips.txt 줄 수 == 노드 수" "$NODES" "$(grep -c . "$F" 2>/dev/null)"
OK=1
while read -r n ip; do grep -q "^$n $ip$" "$F" 2>/dev/null || OK=0; done < <($K get no -o jsonpath='{range .items[*]}{.metadata.name} {.status.addresses[?(@.type=="InternalIP")].address}{"\n"}{end}' 2>/dev/null)
expect "각 노드 '이름 InternalIP' 일치" test "$OK" -eq 1
expect "pv-sorted.txt 존재 & 비어있지 않음" test -s "$OUT/pv-sorted.txt"
ORDER=$(awk '/^pv-[abc][[:space:]]/{print $1}' "$OUT/pv-sorted.txt" 2>/dev/null | tr '\n' ' ')
expect_eq "PV 용량 오름차순 (pv-b pv-c pv-a)" "pv-b pv-c pv-a " "$ORDER"
q_end; report
