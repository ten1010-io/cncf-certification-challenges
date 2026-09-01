#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0004
ns_ensure api
# 재실행 시 revision 히스토리를 초기화하기 위해 삭제 후 생성
$K -n api delete deploy api --ignore-not-found --wait=true >/dev/null
$K -n api create deploy api --image=nginx:1.24 --replicas=2 >/dev/null
wait_deploy api api
jp api deploy/api '{.metadata.uid}' > "$STATE/api-uid"
