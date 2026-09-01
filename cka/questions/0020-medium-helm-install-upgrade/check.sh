#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0020
q_start 0020 6 "Helm 설치와 업그레이드"
HJ=$(helm --kube-context "$CTX" list -n helm-shop -o json 2>/dev/null | tr -d ' ')
expect_contains "릴리스 shop-web 의 chart 가 webapp-0.2.0" '"chart":"webapp-0.2.0"' "$HJ"
REVS=$(helm --kube-context "$CTX" history shop-web -n helm-shop -o json 2>/dev/null | grep -o '"chart":"[^"]*"' | cut -d'"' -f4 | paste -sd, -)
expect_contains "history 에 webapp-0.1.0 -> webapp-0.2.0" "webapp-0.1.0,webapp-0.2.0" "$REVS"
expect_eq "deployment shop-web-webapp replicas 2 유지" "2" "$(jp helm-shop deploy/shop-web-webapp '{.spec.replicas}')"
expect "helm-history.txt 존재 & 비어있지 않음" test -s "$OUT/helm-history.txt"
q_end; report
