#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0001
q_start 0001 4 "RBAC ServiceAccount 권한 부여"
expect "SA deploy-bot 존재" $K -n ci get sa deploy-bot
expect "Role deploy-manager 존재" $K -n ci get role deploy-manager
expect "RoleBinding deploy-bot-rb 존재" $K -n ci get rolebinding deploy-bot-rb
SA="system:serviceaccount:ci:deploy-bot"
expect_eq "create deployments in ci" "yes" "$($K auth can-i create deployments --as=$SA -n ci 2>/dev/null)"
expect_eq "delete deployments in ci" "yes" "$($K auth can-i delete deployments --as=$SA -n ci 2>/dev/null)"
expect_eq "list pods in ci" "yes" "$($K auth can-i list pods --as=$SA -n ci 2>/dev/null)"
expect_eq "delete pods in ci 는 불가" "no" "$($K auth can-i delete pods --as=$SA -n ci 2>/dev/null)"
expect_eq "create deployments in default 는 불가" "no" "$($K auth can-i create deployments --as=$SA -n default 2>/dev/null)"
q_end; report
