#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0015
if [[ -s "$STATE/coredns-cm.yaml" ]]; then
  $K apply -f "$STATE/coredns-cm.yaml" >/dev/null 2>&1 || true
else
  $K -n kube-system get cm coredns -o yaml | sed 's/cluster\.locall/cluster.local/g' | $K apply -f - >/dev/null 2>&1 || true
fi
$K -n kube-system rollout restart deploy coredns >/dev/null 2>&1 || true
rm -f "$STATE/coredns-cm.yaml"
