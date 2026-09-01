#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0012
q_start 0012 5 "Gateway API — Gateway + HTTPRoute"
expect "gateway shop-gw 존재" $K -n shop-gw get gateway shop-gw
expect_eq "gatewayClassName nginx" "nginx" "$(jp shop-gw gateway/shop-gw '{.spec.gatewayClassName}')"
expect_eq "listener http/HTTP/80" "http HTTP 80" "$(jp shop-gw gateway/shop-gw '{.spec.listeners[0].name} {.spec.listeners[0].protocol} {.spec.listeners[0].port}')"
expect "httproute shop-route 존재" $K -n shop-gw get httproute shop-route
expect_eq "parentRef shop-gw" "shop-gw" "$(jp shop-gw httproute/shop-route '{.spec.parentRefs[0].name}')"
expect_eq "hostname shop.local" "shop.local" "$(jp shop-gw httproute/shop-route '{.spec.hostnames[0]}')"
RULES=$(jp shop-gw httproute/shop-route '{range .spec.rules[*]}{.matches[0].path.type}:{.matches[0].path.value}={.backendRefs[0].name}:{.backendRefs[0].port}{"\n"}{end}')
expect_contains "PathPrefix /api → shop-api:80" "PathPrefix:/api=shop-api:80" "$RULES"
expect_contains "PathPrefix / → shop-web:80" "PathPrefix:/=shop-web:80" "$RULES"
q_end; report
