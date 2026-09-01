#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0033
q_start 0033 5 "노드 유지보수 (drain)"
expect_eq "노드 $W2 unschedulable" "true" "$(cjp "node/$W2" '{.spec.unschedulable}')"
NONDS=$($K get po -A --field-selector spec.nodeName="$W2" -o json 2>/dev/null | python3 -c '
import json,sys
pods=json.load(sys.stdin)["items"]
print(sum(1 for p in pods if not any(o.get("kind")=="DaemonSet" for o in p["metadata"].get("ownerReferences",[])) and p["status"]["phase"]!="Succeeded"))' 2>/dev/null)
expect "$W2 에 DaemonSet 외 Pod 없음 (실제 ${NONDS:-?})" test "${NONDS:-1}" -eq 0
q_end; report
