#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0017
ns_ensure checkout
$K -n checkout create deploy checkout --image=nginx:1.25 --port=80 --replicas=2 --dry-run=client -o yaml | $K apply -f - >/dev/null
cat <<'Y' | $K apply -f - >/dev/null
apiVersion: v1
kind: Service
metadata: {name: checkout-svc, namespace: checkout}
spec:
  selector: {app: checkout-v1}
  ports:
    - port: 80
      targetPort: 8080
      protocol: TCP
Y
wait_deploy checkout checkout
jp checkout deploy/checkout '{.metadata.uid}' > "$STATE/checkout-uid"
