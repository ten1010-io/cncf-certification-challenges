#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0005
ns_delete batch
$K taint no "$W1" dedicated- >/dev/null 2>&1 || true
$K label no "$W1" workload- >/dev/null 2>&1 || true
