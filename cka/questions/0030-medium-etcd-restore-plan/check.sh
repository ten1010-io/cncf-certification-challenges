#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0030
q_start 0030 5 "etcd 스냅샷 + 복원 절차 작성"
expect "스냅샷 파일 /opt/snapshot-02.db 존재 (비어있지 않음)" node_exec "$CP_NODE" test -s /opt/snapshot-02.db
STATUS=$(node_sh "$CP_NODE" 'etcdutl snapshot status /opt/snapshot-02.db 2>/dev/null || ETCDCTL_API=3 etcdctl snapshot status /opt/snapshot-02.db 2>/dev/null')
expect "스냅샷 status 정상 (유효한 etcd 스냅샷)" test -n "$STATUS"
F="$OUT/etcd-restore.sh"
expect "etcd-restore.sh 존재 & 비어있지 않음" test -s "$F"
C=$(cat "$F" 2>/dev/null)
expect_contains "snapshot restore 명령" "snapshot restore" "$C"
expect_contains "--data-dir 지정" "--data-dir" "$C"
expect_contains "새 디렉토리 /var/lib/etcd-restore" "/var/lib/etcd-restore" "$C"
expect_contains "etcd.yaml 매니페스트 수정 언급" "etcd.yaml" "$C"
expect "etcd 데이터 디렉토리가 실제로 바뀌지 않음 (실행 금지)" node_sh "$CP_NODE" 'grep -q "path: /var/lib/etcd$" /etc/kubernetes/manifests/etcd.yaml'
q_end; report
