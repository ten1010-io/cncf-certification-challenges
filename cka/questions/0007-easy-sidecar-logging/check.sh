#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0007
q_start 0007 4 "사이드카 로깅 (emptyDir 공유)"
expect_eq "Running" "Running" "$(jp default pod/logger '{.status.phase}')"
CN=$(jp default pod/logger '{.spec.containers[*].name}')
expect_contains "컨테이너 app" "app" "$CN"
expect_contains "컨테이너 shipper" "shipper" "$CN"
expect "emptyDir 볼륨 logs" test -n "$(jp default pod/logger '{.spec.volumes[?(@.name=="logs")].emptyDir}')"
MOUNTS=$(jp default pod/logger '{range .spec.containers[*]}{.name}={.volumeMounts[?(@.name=="logs")].mountPath}{" "}{end}')
expect_contains "app 이 logs 를 /var/log 에 마운트" "app=/var/log" "$MOUNTS"
expect_contains "shipper 가 logs 를 /var/log 에 마운트" "shipper=/var/log" "$MOUNTS"
LOG=$($K -n default logs logger -c shipper --tail=5 2>/dev/null)
expect "shipper 로그에 날짜 출력 (기능)" test "$(grep -cE '[0-9]{4}' <<<"$LOG")" -gt 0
q_end; report
