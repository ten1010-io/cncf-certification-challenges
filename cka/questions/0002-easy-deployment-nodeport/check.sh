#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0002
q_start 0002 4 "Deployment + NodePort Service"
expect_eq "web readyReplicas 3" "3" "$(jp frontend deploy/web '{.status.readyReplicas}')"
expect_contains "이미지 nginx:1.25" "nginx:1.25" "$(jp frontend deploy/web '{.spec.template.spec.containers[0].image}')"
expect_eq "Pod 라벨 app=web" "web" "$(jp frontend deploy/web '{.spec.template.metadata.labels.app}')"
expect_eq "svc type NodePort" "NodePort" "$(jp frontend svc/web-svc '{.spec.type}')"
expect_eq "port 80" "80" "$(jp frontend svc/web-svc '{.spec.ports[0].port}')"
expect_eq "nodePort 30080" "30080" "$(jp frontend svc/web-svc '{.spec.ports[0].nodePort}')"
EP=$(jp frontend endpoints/web-svc '{.subsets[0].addresses[*].ip}' | wc -w | tr -d ' ')
expect_eq "endpoints 3개" "3" "$EP"
NODE_IP=$(cjp "node/$W1" '{.status.addresses[?(@.type=="InternalIP")].address}')
client_ensure
expect "NodePort 30080 응답 (기능)" http_ok "http://$NODE_IP:30080" nginx
q_end; report
