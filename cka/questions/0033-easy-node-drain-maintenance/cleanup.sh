#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0033
$K uncordon "$W2" >/dev/null 2>&1 || true
ns_delete maint
