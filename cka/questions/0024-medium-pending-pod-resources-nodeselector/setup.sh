#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0024
ns_ensure heavy
$K label no "$W1" disktype- >/dev/null 2>&1 || true
echo "==> heavy (Pending: memory 64Gi + nodeSelector disktype=ssd, 라벨 가진 노드 없음)"
cat <<'Y' | $K apply -f - >/dev/null
apiVersion: apps/v1
kind: Deployment
metadata: {name: heavy, namespace: heavy}
spec:
  replicas: 1
  selector: {matchLabels: {app: heavy}}
  template:
    metadata: {labels: {app: heavy}}
    spec:
      nodeSelector: {disktype: ssd}
      containers:
        - name: heavy
          image: nginx:1.25
          resources:
            requests: {memory: 64Gi, cpu: 100m}
            limits:   {memory: 64Gi, cpu: 100m}
Y
