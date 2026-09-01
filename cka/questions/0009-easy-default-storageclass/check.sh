#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0009
q_start 0009 4 "기본 StorageClass 변경"
ANN='storageclass\.kubernetes\.io/is-default-class'
expect_eq "provisioner no-provisioner" "kubernetes.io/no-provisioner" "$(cjp sc/fast-local '{.provisioner}')"
expect_eq "volumeBindingMode WaitForFirstConsumer" "WaitForFirstConsumer" "$(cjp sc/fast-local '{.volumeBindingMode}')"
expect_eq "reclaimPolicy Retain" "Retain" "$(cjp sc/fast-local '{.reclaimPolicy}')"
expect_eq "fast-local 이 default" "true" "$(cjp sc/fast-local "{.metadata.annotations.$ANN}")"
expect_ne "standard 는 default 아님" "true" "$(cjp sc/standard "{.metadata.annotations.$ANN}")"
DEFAULTS=$($K get sc -o jsonpath='{range .items[*]}{.metadata.name}={.metadata.annotations.storageclass\.kubernetes\.io/is-default-class}{"\n"}{end}' 2>/dev/null | grep -c '=true$')
expect_eq "기본 SC 는 1개" "1" "$DEFAULTS"
q_end; report
