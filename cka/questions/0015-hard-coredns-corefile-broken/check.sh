#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0015
q_start 0015 8 "CoreDNS Corefile 복구 (DNS 장애)"
CF=$(jp kube-system cm/coredns '{.data.Corefile}')
expect_not_contains "Corefile 에 'cluster.locall' 없음" "cluster.locall" "$CF"
expect_contains "Corefile 에 'kubernetes cluster.local'" "kubernetes cluster.local" "$CF"
client_ensure
R=$(client_exec nslookup kubernetes.default.svc.cluster.local 2>/dev/null | grep -c "Address")
expect_ge "pod 에서 kubernetes.default.svc.cluster.local 해석 성공 (기능)" 2 "${R:-0}"
expect "coredns deployment 존재 (재생성 금지)" $K -n kube-system get deploy coredns
q_end; report
