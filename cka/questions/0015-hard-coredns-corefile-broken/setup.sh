#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0015
# 정상 Corefile 백업 (이미 고장 주입된 상태에서 재실행되면 기존 백업 유지)
if ! $K -n kube-system get cm coredns -o jsonpath='{.data.Corefile}' | grep -q 'cluster.locall'; then
  $K -n kube-system get cm coredns -o json | python3 -c '
import json,sys
cm=json.load(sys.stdin)
for k in ("resourceVersion","uid","creationTimestamp","managedFields"): cm["metadata"].pop(k,None)
print(json.dumps(cm))' > "$STATE/coredns-cm.yaml"
fi
echo "==> CoreDNS Corefile 고장 주입 (cluster.local -> cluster.locall)"
$K -n kube-system get cm coredns -o json \
  | python3 -c '
import json,sys
cm=json.load(sys.stdin)
cf=cm["data"]["Corefile"].replace("kubernetes cluster.local","kubernetes cluster.locall")
cm["data"]["Corefile"]=cf
for k in ("resourceVersion","uid","creationTimestamp","managedFields"): cm["metadata"].pop(k,None)
print(json.dumps(cm))' | $K apply -f - >/dev/null
$K -n kube-system rollout restart deploy coredns >/dev/null
wait_deploy kube-system coredns 120s
echo "CoreDNS 가 cluster.local 존을 서비스하지 않는다. 클러스터 내부 Service 이름 해석 실패."
