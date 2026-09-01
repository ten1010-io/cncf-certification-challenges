#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0027
$K -n web delete httproute app-route --ignore-not-found >/dev/null 2>&1 || true
$K -n web delete gateway web-gw --ignore-not-found >/dev/null 2>&1 || true
ns_delete web
