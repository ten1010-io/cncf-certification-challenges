#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0027
ns_ensure web
for n in app-svc app-v2-svc; do
  $K -n web create deploy "$n" --image=nginx:1.25 --port=80 --dry-run=client -o yaml | $K apply -f - >/dev/null
  $K -n web expose deploy "$n" --port=80 --dry-run=client -o yaml | $K apply -f - >/dev/null
done
$K -n web create ingress legacy --class=nginx --rule="app.local/*=app-svc:80" --rule="app.local/v2*=app-v2-svc:80" --dry-run=client -o yaml | $K apply -f - >/dev/null
$K -n web delete gateway web-gw --ignore-not-found >/dev/null 2>&1 || true
$K -n web delete httproute app-route --ignore-not-found >/dev/null 2>&1 || true
wait_deploy web app-svc
wait_deploy web app-v2-svc
