#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0010
ns_ensure np-backend np-frontend np-other
$K -n np-backend run db --image=nginx:1.25 --labels=app=db --port=80 --dry-run=client -o yaml | $K apply -f - >/dev/null
$K -n np-frontend run web --image=busybox:1.36 --labels=app=web --command --dry-run=client -o yaml -- sleep 360000 | $K apply -f - >/dev/null
# 함정용: 다른 네임스페이스에 같은 라벨(app=web)을 가진 Pod. OR 로 잘못 쓴 정책은 이 Pod 를 허용해 버린다.
$K -n np-other run intruder --image=busybox:1.36 --labels=app=web --command --dry-run=client -o yaml -- sleep 360000 | $K apply -f - >/dev/null
wait_ready_pod np-backend db
wait_ready_pod np-frontend web
wait_ready_pod np-other intruder
