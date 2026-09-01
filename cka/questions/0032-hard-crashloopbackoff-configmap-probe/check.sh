#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0032
q_start 0032 7 "CrashLoopBackOff 복구 (ConfigMap 키 + liveness)"
expect_eq "Deployment 미재생성 (uid 유지)" "$(cat "$STATE/payments-uid" 2>/dev/null)" "$(jp payments deploy/payments '{.metadata.uid}')"
expect_eq "readyReplicas 1" "1" "$(jp payments deploy/payments '{.status.readyReplicas}')"
expect_contains "command 가 /config/app.conf 를 읽음" "/config/app.conf" "$(jp payments deploy/payments '{.spec.template.spec.containers[0].command[*]}')"
expect_contains "볼륨이 CM payments-cfg 사용" "payments-cfg" "$(jp payments deploy/payments '{.spec.template.spec.volumes[*].configMap.name}')"
expect "CM payments-cfg 존재" $K -n payments get cm payments-cfg
RS=$($K -n payments get po -l app=payments --field-selector=status.phase=Running -o jsonpath='{.items[0].status.containerStatuses[0].restartCount}' 2>/dev/null)
expect "Running Pod 의 재시작 안정 (restartCount<3, 실제 ${RS:-?})" test "${RS:-99}" -lt 3
POD=$($K -n payments get po -l app=payments --field-selector=status.phase=Running -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)
expect "컨테이너 안 /config/app.conf 존재 (기능)" $K -n payments exec "${POD:-none}" -- test -s /config/app.conf
q_end; report
