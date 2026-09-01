#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0007
$K -n default delete po logger --ignore-not-found --force --grace-period=0 >/dev/null 2>&1 || true
