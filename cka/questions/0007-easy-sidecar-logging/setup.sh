#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0007
# default 네임스페이스는 공유 공간이라 이전 시도의 Pod 만 제거한다
$K -n default delete po logger --ignore-not-found --force --grace-period=0 >/dev/null 2>&1 || true
