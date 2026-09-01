#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0003
ns_ensure catalog
# 재실행 시 고장 상태로 되돌린다: 사용자가 만든 CM 제거, deployment 재생성
$K -n catalog delete cm catalog-cfg --ignore-not-found >/dev/null
$K -n catalog delete deploy catalog --ignore-not-found --wait=true >/dev/null
cat <<'Y' | $K apply -f - >/dev/null
apiVersion: apps/v1
kind: Deployment
metadata: {name: catalog, namespace: catalog, labels: {app: catalog}}
spec:
  replicas: 2
  selector: {matchLabels: {app: catalog}}
  template:
    metadata: {labels: {app: catalog}}
    spec:
      containers:
        - name: catalog
          image: ngnix:1.25
          ports: [{containerPort: 80}]
          envFrom:
            - configMapRef: {name: catalog-cfg}
Y
jp catalog deploy/catalog '{.metadata.uid}' > "$STATE/catalog-uid"
