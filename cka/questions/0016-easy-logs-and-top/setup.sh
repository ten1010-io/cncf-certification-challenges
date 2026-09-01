#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0016
ns_ensure load
rm -f "$OUT/crasher.log" "$OUT/top-cpu.txt"
cat <<'Y' | $K apply -f - >/dev/null
apiVersion: v1
kind: Pod
metadata: {name: crasher, namespace: default}
spec:
  containers:
    - name: app
      image: busybox:1.36
      command: ["sh","-c","echo 'INFO: starting app v2.3'; echo 'FATAL: config file /etc/app/config.yaml not found'; exit 1"]
---
apiVersion: v1
kind: Pod
metadata: {name: busy, namespace: load, labels: {app: busy}}
spec:
  containers:
    - name: burn
      image: busybox:1.36
      command: ["sh","-c","yes > /dev/null"]
      resources: {requests: {cpu: 50m}, limits: {cpu: 200m}}
---
apiVersion: v1
kind: Pod
metadata: {name: idle, namespace: load, labels: {app: idle}}
spec:
  containers:
    - name: nap
      image: busybox:1.36
      command: ["sleep","36000"]
      resources: {requests: {cpu: 50m}, limits: {cpu: 200m}}
Y
wait_ready_pod load busy
wait_ready_pod load idle
$K -n kube-system get deploy metrics-server >/dev/null 2>&1 || echo "WARN: metrics-server 없음. kubectl top 이 동작하지 않는다. common/setup/create-cluster.sh 확인."
echo "busy 의 CPU 사용량이 metrics-server 에 잡히기까지 ~1분."
