#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0034
rm -f "$OUT/node-ips.txt" "$OUT/pv-sorted.txt"
for spec in "pv-a 3Gi" "pv-b 1Gi" "pv-c 2Gi"; do
  set -- $spec
  cat <<Y | $K apply -f - >/dev/null
apiVersion: v1
kind: PersistentVolume
metadata: {name: $1}
spec:
  capacity: {storage: $2}
  accessModes: [ReadWriteOnce]
  storageClassName: sort-test
  hostPath: {path: /mnt/$1}
Y
done
