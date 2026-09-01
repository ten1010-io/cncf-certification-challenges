#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0022
rm -f "$OUT/crds.txt"
echo "==> CRD shirts.stable.example.com"
cat <<'Y' | $K apply -f - >/dev/null
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata: {name: shirts.stable.example.com}
spec:
  group: stable.example.com
  scope: Namespaced
  names: {plural: shirts, singular: shirt, kind: Shirt, shortNames: [sh]}
  versions:
    - name: v1
      served: true
      storage: true
      schema:
        openAPIV3Schema:
          type: object
          properties:
            spec:
              type: object
              properties:
                color: {type: string, description: "Shirt color"}
                size: {type: string, enum: [S, M, L, XL], description: "Shirt size"}
Y
$K wait --for=condition=Established crd/shirts.stable.example.com --timeout=60s >/dev/null
$K -n default delete shirt blue-shirt --ignore-not-found >/dev/null 2>&1 || true
