#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0021
rm -rf "$OUT/kustomize"
mkdir -p "$OUT/kustomize/base"
echo "==> kustomize base -> $OUT/kustomize/base/"
cat > "$OUT/kustomize/base/deployment.yaml" <<'Y'
apiVersion: apps/v1
kind: Deployment
metadata: {name: web, labels: {app: web}}
spec:
  replicas: 1
  selector: {matchLabels: {app: web}}
  template:
    metadata: {labels: {app: web}}
    spec:
      containers:
        - name: nginx
          image: nginx:1.24
          ports: [{containerPort: 80}]
Y
cat > "$OUT/kustomize/base/service.yaml" <<'Y'
apiVersion: v1
kind: Service
metadata: {name: web}
spec:
  selector: {app: web}
  ports: [{port: 80, targetPort: 80}]
Y
cat > "$OUT/kustomize/base/kustomization.yaml" <<'Y'
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - deployment.yaml
  - service.yaml
Y
ls "$OUT/kustomize/base"
