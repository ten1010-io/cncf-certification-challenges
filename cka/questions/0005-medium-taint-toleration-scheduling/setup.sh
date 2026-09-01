#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0005
ns_ensure batch
$K taint no "$W1" dedicated=batch:NoSchedule --overwrite >/dev/null
$K label no "$W1" workload=batch --overwrite >/dev/null
