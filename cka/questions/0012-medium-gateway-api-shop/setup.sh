#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0012
$K get crd gateways.gateway.networking.k8s.io >/dev/null 2>&1 || echo "WARN: Gateway API CRD 없음. common/setup/create-cluster.sh 의 Gateway API 설치 단계 확인."
ns_ensure shop-gw
for n in shop-web shop-api; do
  $K -n shop-gw create deploy "$n" --image=nginx:1.25 --port=80 --dry-run=client -o yaml | $K apply -f - >/dev/null
  $K -n shop-gw expose deploy "$n" --port=80 --dry-run=client -o yaml | $K apply -f - >/dev/null
done
wait_deploy shop-gw shop-web
wait_deploy shop-gw shop-api
