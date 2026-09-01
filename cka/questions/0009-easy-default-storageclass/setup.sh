#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0009
# 시작 상태: standard 가 유일한 기본 SC, fast-local 없음
$K delete sc fast-local --ignore-not-found >/dev/null
$K patch sc standard -p '{"metadata":{"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}' >/dev/null
