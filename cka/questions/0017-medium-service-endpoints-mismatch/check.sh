#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0017
q_start 0017 7 "Service 연결 불가 (selector, targetPort 불일치)"
expect_eq "selector app=checkout" "checkout" "$(jp checkout svc/checkout-svc '{.spec.selector.app}')"
EP=$(jp checkout endpoints/checkout-svc '{.subsets[0].addresses[*].ip}' | wc -w | tr -d ' ')
expect_ge "endpoints 존재" 1 "${EP:-0}"
expect_eq "deployment 미변경 (uid 동일)" "$(cat "$STATE/checkout-uid" 2>/dev/null)" "$(jp checkout deploy/checkout '{.metadata.uid}')"
SVCIP=$(jp checkout svc/checkout-svc '{.spec.clusterIP}')
client_ensure
expect "checkout-svc:80 응답 (기능)" http_ok "http://$SVCIP:80" nginx
q_end; report
