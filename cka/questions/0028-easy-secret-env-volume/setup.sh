#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0028
ns_ensure secure-app
$K -n secure-app delete pod secure-app --ignore-not-found --force --grace-period=0 >/dev/null 2>&1 || true
$K -n secure-app delete secret db-creds --ignore-not-found >/dev/null 2>&1 || true
