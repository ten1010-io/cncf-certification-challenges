#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0027
q_start 0027 7 "Ingress → Gateway API 마이그레이션"
if $K -n web get ingress legacy >/dev/null 2>&1; then expect "Ingress legacy 삭제됨" false; else expect "Ingress legacy 삭제됨" true; fi
expect "Gateway web-gw 존재" $K -n web get gateway web-gw
expect_eq "gatewayClassName nginx" "nginx" "$(jp web gateway/web-gw '{.spec.gatewayClassName}')"
expect_eq "listener http/HTTP/80" "http HTTP 80" "$(jp web gateway/web-gw '{.spec.listeners[0].name} {.spec.listeners[0].protocol} {.spec.listeners[0].port}')"
expect "HTTPRoute app-route 존재" $K -n web get httproute app-route
expect_eq "parentRef web-gw" "web-gw" "$(jp web httproute/app-route '{.spec.parentRefs[0].name}')"
expect_eq "hostname app.local" "app.local" "$(jp web httproute/app-route '{.spec.hostnames[0]}')"
RULES=$(jp web httproute/app-route '{range .spec.rules[*]}{.matches[0].path.type}:{.matches[0].path.value}={.backendRefs[0].name}:{.backendRefs[0].port}{"\n"}{end}')
expect_contains "/v2 → app-v2-svc:80 (PathPrefix)" "PathPrefix:/v2=app-v2-svc:80" "$RULES"
expect_contains "/ → app-svc:80 (PathPrefix)" "PathPrefix:/=app-svc:80" "$RULES"
q_end; report
