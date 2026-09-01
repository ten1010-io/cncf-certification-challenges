#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0032
ns_ensure payments
$K -n payments delete deploy payments --ignore-not-found >/dev/null 2>&1 || true
$K -n payments delete cm payments-cfg --ignore-not-found >/dev/null 2>&1 || true
# 고장 1: CM 키가 settings.conf (앱은 app.conf 를 읽음)
$K -n payments create cm payments-cfg --from-literal=settings.conf="mode=prod" >/dev/null
# 고장 2: HTTP liveness (컨테이너는 웹서버가 아님)
cat <<'Y' | $K apply -f - >/dev/null
apiVersion: apps/v1
kind: Deployment
metadata: {name: payments, namespace: payments}
spec:
  replicas: 1
  selector: {matchLabels: {app: payments}}
  template:
    metadata: {labels: {app: payments}}
    spec:
      volumes:
        - name: cfg
          configMap: {name: payments-cfg}
      containers:
        - name: payments
          image: busybox:1.36
          command: ["sh","-c","cat /config/app.conf && sleep 3600"]
          volumeMounts: [{name: cfg, mountPath: /config}]
          livenessProbe:
            httpGet: {path: /healthz, port: 80}
            initialDelaySeconds: 5
            periodSeconds: 5
Y
jp payments deploy/payments '{.metadata.uid}' > "$STATE/payments-uid"
echo "payments Pod 는 CrashLoopBackOff 로 남는다 (의도된 고장)."
