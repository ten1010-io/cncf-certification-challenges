#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0010
q_start 0010 7 "NetworkPolicy — frontend 만 허용"
expect "netpol db-allow-web 존재" $K -n np-backend get netpol db-allow-web
expect_eq "podSelector app=db" "db" "$(jp np-backend netpol/db-allow-web '{.spec.podSelector.matchLabels.app}')"
PT=$(jp np-backend netpol/db-allow-web '{.spec.policyTypes[*]}')
expect_contains "policyTypes 에 Ingress" "Ingress" "$PT"
expect_not_contains "policyTypes 에 Egress 없음 (egress 제한 금지)" "Egress" "$PT"
expect "from 항목에 namespaceSelector 와 podSelector 가 함께 (AND)" test -n "$(jp np-backend netpol/db-allow-web '{.spec.ingress[0].from[0].namespaceSelector}')" -a -n "$(jp np-backend netpol/db-allow-web '{.spec.ingress[0].from[0].podSelector}')"
DBIP=$(jp np-backend pod/db '{.status.podIP}')
if [[ -n "$DBIP" ]]; then
  ALLOWED=$($K -n np-frontend exec web -- wget -qO- -T 3 "http://$DBIP" 2>/dev/null | grep -c nginx)
  expect "np-frontend/web → db 허용 (기능)" test "${ALLOWED:-0}" -gt 0
  DENIED=$($K -n np-other exec intruder -- wget -qO- -T 3 "http://$DBIP" 2>/dev/null | grep -c nginx)
  expect "np-other/intruder(app=web) → db 차단 (기능)" test "${DENIED:-0}" -eq 0
else
  expect "db Pod IP 조회" false
fi
q_end; report
