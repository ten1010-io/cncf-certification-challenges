#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0031
q_start 0031 5 "kubeadm control-plane 업그레이드 절차 작성"
F="$OUT/upgrade-cp.sh"; C=$(cat "$F" 2>/dev/null)
expect "upgrade-cp.sh 존재 & 비어있지 않음" test -s "$F"
expect_contains "노드 drain" "drain" "$C"
expect_contains "kubeadm upgrade plan" "kubeadm upgrade plan" "$C"
expect_contains "kubeadm upgrade apply v1.35" "kubeadm upgrade apply v1.35" "$C"
expect_contains "kubelet 설치/업그레이드" "kubelet" "$C"
expect_contains "systemctl restart kubelet" "systemctl restart kubelet" "$C"
expect_contains "노드 uncordon" "uncordon" "$C"
q_end; report
