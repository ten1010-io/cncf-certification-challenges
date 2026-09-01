#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0021
q_start 0021 5 "Kustomize overlay 작성과 적용"
expect "overlays/prod/kustomization.yaml 존재" test -f "$OUT/kustomize/overlays/prod/kustomization.yaml"
expect_eq "kprod/prod-web replicas 3" "3" "$(jp kprod deploy/prod-web '{.spec.replicas}')"
expect_eq "이미지 nginx:1.25" "nginx:1.25" "$(jp kprod deploy/prod-web '{.spec.template.spec.containers[0].image}')"
expect "svc kprod/prod-web 존재" $K -n kprod get svc prod-web
expect_eq "readyReplicas 3" "3" "$(jp kprod deploy/prod-web '{.status.readyReplicas}')"
q_end; report
