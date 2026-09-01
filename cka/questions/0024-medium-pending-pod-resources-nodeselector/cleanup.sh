#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0024
ns_delete heavy
$K label no "$W1" disktype- >/dev/null 2>&1
