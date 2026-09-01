#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0029
ns_ensure logs
for n in "$CP_NODE" "$W1" "$W2"; do node_exec "$n" mkdir -p /mnt/logs >/dev/null 2>&1 || true; done
$K -n logs delete pod log-writer --ignore-not-found --force --grace-period=0 >/dev/null 2>&1 || true
$K -n logs delete pvc logs-pvc --ignore-not-found >/dev/null 2>&1 || true
$K delete pv pv-logs --ignore-not-found >/dev/null 2>&1 || true
cat <<'Y' | $K apply -f - >/dev/null
apiVersion: v1
kind: PersistentVolume
metadata: {name: pv-logs}
spec:
  capacity: {storage: 2Gi}
  accessModes: [ReadWriteMany]
  persistentVolumeReclaimPolicy: Retain
  storageClassName: logs
  hostPath: {path: /mnt/logs}
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata: {name: logs-pvc, namespace: logs}
spec:
  accessModes: [ReadWriteOnce]
  storageClassName: logs
  resources: {requests: {storage: 2Gi}}
---
apiVersion: v1
kind: Pod
metadata: {name: log-writer, namespace: logs}
spec:
  volumes:
    - name: logs
      persistentVolumeClaim: {claimName: logs-pvc}
  containers:
    - name: w
      image: busybox:1.36
      command: ["sh","-c","while true; do date >> /logs/out.log; sleep 5; done"]
      volumeMounts: [{name: logs, mountPath: /logs}]
Y
cjp pv/pv-logs '{.metadata.uid}' > "$STATE/pv-uid"
echo "logs-pvc 는 accessModes 불일치로 Pending, log-writer 는 Pending 상태로 남는다 (의도된 고장)."
