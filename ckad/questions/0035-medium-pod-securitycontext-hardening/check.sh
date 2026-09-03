#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0035
q_start 0035 4 "SecurityContext 로 컨테이너 권한 제한"
expect_eq "Pod Running" "Running" "$(jp sec-ctx pod/hardened '{.status.phase}')"
expect_contains "이미지 busybox:1.36" "busybox:1.36" "$(jp sec-ctx pod/hardened '{.spec.containers[0].image}')"
expect_eq "Pod runAsUser 1000" "1000" "$(jp sec-ctx pod/hardened '{.spec.securityContext.runAsUser}')"
expect_eq "Pod runAsGroup 3000" "3000" "$(jp sec-ctx pod/hardened '{.spec.securityContext.runAsGroup}')"
expect_eq "Pod fsGroup 2000" "2000" "$(jp sec-ctx pod/hardened '{.spec.securityContext.fsGroup}')"
expect_eq "allowPrivilegeEscalation false" "false" "$(jp sec-ctx pod/hardened '{.spec.containers[0].securityContext.allowPrivilegeEscalation}')"
expect_eq "readOnlyRootFilesystem true" "true" "$(jp sec-ctx pod/hardened '{.spec.containers[0].securityContext.readOnlyRootFilesystem}')"
expect_contains "capabilities add NET_ADMIN" "NET_ADMIN" "$(jp sec-ctx pod/hardened '{.spec.containers[0].securityContext.capabilities.add[*]}')"
expect_eq "컨테이너 안 id -u 가 1000 (기능)" "1000" "$($K -n sec-ctx exec hardened -- id -u 2>/dev/null | tr -d '\r\n')"
q_end; report
