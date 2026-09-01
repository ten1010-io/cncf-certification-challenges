#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0008
q_start 0008 7 "PV / PVC (hostPath, manual)"
expect_eq "PV 용량 1Gi" "1Gi" "$(cjp pv/pv-orders '{.spec.capacity.storage}')"
expect_eq "PV accessMode RWO" "ReadWriteOnce" "$(cjp pv/pv-orders '{.spec.accessModes[0]}')"
expect_eq "PV storageClassName manual" "manual" "$(cjp pv/pv-orders '{.spec.storageClassName}')"
expect_eq "PV reclaimPolicy Retain" "Retain" "$(cjp pv/pv-orders '{.spec.persistentVolumeReclaimPolicy}')"
expect_eq "PV hostPath /mnt/orders" "/mnt/orders" "$(cjp pv/pv-orders '{.spec.hostPath.path}')"
expect_eq "PVC Bound" "Bound" "$(jp orders pvc/orders-pvc '{.status.phase}')"
expect_eq "PVC → pv-orders" "pv-orders" "$(jp orders pvc/orders-pvc '{.spec.volumeName}')"
expect_eq "PVC 요청 500Mi" "500Mi" "$(jp orders pvc/orders-pvc '{.spec.resources.requests.storage}')"
expect_eq "PVC storageClassName manual" "manual" "$(jp orders pvc/orders-pvc '{.spec.storageClassName}')"
expect_eq "Pod Running" "Running" "$(jp orders pod/orders-db '{.status.phase}')"
expect_contains "Pod 이미지 busybox:1.36" "busybox:1.36" "$(jp orders pod/orders-db '{.spec.containers[0].image}')"
expect_contains "Pod 가 orders-pvc 사용" "orders-pvc" "$(jp orders pod/orders-db '{.spec.volumes[*].persistentVolumeClaim.claimName}')"
expect_contains "마운트 /data" "/data" "$(jp orders pod/orders-db '{.spec.containers[0].volumeMounts[*].mountPath}')"
q_end; report
