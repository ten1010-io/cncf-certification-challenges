#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0026
q_start 0026 7 "NetworkPolicy default-deny + DNS 허용"
expect "default-deny 존재" $K -n secure get netpol default-deny
expect "allow-dns 존재" $K -n secure get netpol allow-dns
PT=$(jp secure netpol/default-deny '{.spec.policyTypes[*]}')
expect_contains "default-deny policyTypes Ingress" "Ingress" "$PT"
expect_contains "default-deny policyTypes Egress" "Egress" "$PT"
expect_contains "allow-dns egress port 53" "53" "$(jp secure netpol/allow-dns '{.spec.egress[*].ports[*].port}')"
RR=$($K -n secure exec worker -- nslookup kubernetes.default.svc.cluster.local 2>/dev/null | grep -c Address)
expect "worker DNS 해석 성공 (기능)" test "${RR:-0}" -gt 1
PIP=$(jp public pod/nginx '{.status.podIP}')
D=$($K -n secure exec worker -- wget -qO- -T 3 "http://$PIP" 2>&1 | grep -c nginx)
expect "worker → public/nginx HTTP 차단 (기능)" test "${D:-0}" -eq 0
q_end; report
