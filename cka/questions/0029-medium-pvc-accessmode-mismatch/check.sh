#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0029
q_start 0029 7 "PVC Pending (accessModes 불일치)"
expect_eq "PVC logs-pvc Bound" "Bound" "$(jp logs pvc/logs-pvc '{.status.phase}')"
expect_eq "PVC → pv-logs" "pv-logs" "$(jp logs pvc/logs-pvc '{.spec.volumeName}')"
expect_eq "PV pv-logs 미변경 (uid 유지)" "$(cat "$STATE/pv-uid" 2>/dev/null)" "$(cjp pv/pv-logs '{.metadata.uid}')"
expect_eq "PV accessModes 미변경 (ReadWriteMany)" "ReadWriteMany" "$(cjp pv/pv-logs '{.spec.accessModes[0]}')"
expect_eq "Pod log-writer Running" "Running" "$(jp logs pod/log-writer '{.status.phase}')"
expect_contains "log-writer 가 logs-pvc 마운트" "logs-pvc" "$(jp logs pod/log-writer '{.spec.volumes[*].persistentVolumeClaim.claimName}')"
q_end; report
