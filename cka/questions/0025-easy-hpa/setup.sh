#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0025
ns_ensure autoscale
$K -n autoscale delete hpa hpa-web --ignore-not-found >/dev/null 2>&1 || true
cat <<'Y' | $K apply -f - >/dev/null
apiVersion: apps/v1
kind: Deployment
metadata: {name: hpa-web, namespace: autoscale}
spec:
  replicas: 1
  selector: {matchLabels: {app: hpa-web}}
  template:
    metadata: {labels: {app: hpa-web}}
    spec:
      containers:
        - name: nginx
          image: nginx:1.25
          resources: {requests: {cpu: 50m, memory: 32Mi}}
Y
wait_deploy autoscale hpa-web
