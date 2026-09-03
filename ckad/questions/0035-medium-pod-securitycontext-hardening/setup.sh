#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0035
ns_ensure sec-ctx
$K -n sec-ctx delete pod hardened --ignore-not-found --force --grace-period=0 >/dev/null 2>&1 || true
