#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0011
q_start 0011 5 "Ingress 경로 라우팅"
expect "ingress shop-ingress 존재" $K -n shop get ingress shop-ingress
expect_eq "ingressClassName nginx" "nginx" "$(jp shop ingress/shop-ingress '{.spec.ingressClassName}')"
expect_eq "host shop.local" "shop.local" "$(jp shop ingress/shop-ingress '{.spec.rules[0].host}')"
PATHS=$(jp shop ingress/shop-ingress '{range .spec.rules[*].http.paths[*]}{.path}={.backend.service.name}:{.backend.service.port.number}:{.pathType}{"\n"}{end}')
expect_contains "/api → shop-api:80 Prefix" "/api=shop-api:80:Prefix" "$PATHS"
expect_contains "/ → shop-web:80 Prefix" "/=shop-web:80:Prefix" "$PATHS"
if $K -n ingress-nginx get svc ingress-nginx-controller >/dev/null 2>&1; then
  client_ensure
  ING_IP=$(jp ingress-nginx svc/ingress-nginx-controller '{.spec.clusterIP}')
  if client_exec wget -qO- -T 5 --header "Host: shop.local" "http://$ING_IP/" 2>/dev/null | grep -q nginx; then
    info "기능 테스트 통과 (Host: shop.local → 200)"
  else
    info "기능 테스트 실패 (컨트롤러 반영 지연/환경 문제일 수 있음, 점수 미반영)"
  fi
else
  info "ingress-nginx 컨트롤러 없음 — 스펙만 채점"
fi
q_end; report
