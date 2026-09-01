#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0025
q_start 0025 5 "HPA 생성"
expect "HPA hpa-web 존재" $K -n autoscale get hpa hpa-web
expect_eq "scaleTargetRef Deployment/hpa-web" "Deployment/hpa-web" "$(jp autoscale hpa/hpa-web '{.spec.scaleTargetRef.kind}/{.spec.scaleTargetRef.name}')"
expect_eq "minReplicas 2" "2" "$(jp autoscale hpa/hpa-web '{.spec.minReplicas}')"
expect_eq "maxReplicas 6" "6" "$(jp autoscale hpa/hpa-web '{.spec.maxReplicas}')"
CPU=$(jp autoscale hpa/hpa-web '{.spec.metrics[?(@.resource.name=="cpu")].resource.target.averageUtilization}')
[[ -z "$CPU" ]] && CPU=$(jp autoscale hpa/hpa-web '{.spec.targetCPUUtilizationPercentage}')
expect_eq "목표 CPU 사용률 60%" "60" "$CPU"
q_end; report
