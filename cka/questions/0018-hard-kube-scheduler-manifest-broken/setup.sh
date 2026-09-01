#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0018
ns_ensure sched-test
MANIFEST=/etc/kubernetes/manifests/kube-scheduler.yaml
echo "==> kube-scheduler static pod 매니페스트 백업 + 오염 (scheduler.conf -> schedulerr.conf)"
node_sh "$CP_NODE" "test -f /root/kube-scheduler.yaml.orig || cp $MANIFEST /root/kube-scheduler.yaml.orig"
node_exec "$CP_NODE" sed -i 's#--kubeconfig=/etc/kubernetes/scheduler.conf#--kubeconfig=/etc/kubernetes/schedulerr.conf#' "$MANIFEST"
sleep 15
$K -n sched-test create deploy pending-app --image=nginx:1.25 --replicas=2 --dry-run=client -o yaml | $K apply -f - >/dev/null
jp sched-test deploy/pending-app '{.metadata.uid}' > "$STATE/pending-uid"
echo "kube-scheduler 가 기동 실패 중. pending-app Pod 는 Pending 으로 남는다."
