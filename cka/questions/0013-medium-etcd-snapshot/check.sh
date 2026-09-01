#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0013
q_start 0013 8 "etcd 스냅샷 백업"
expect "스냅샷 파일 /opt/snapshot-01.db 존재 (비어있지 않음)" node_exec "$CP_NODE" test -s /opt/snapshot-01.db
STATUS=$(node_sh "$CP_NODE" 'etcdutl snapshot status /opt/snapshot-01.db 2>/dev/null || ETCDCTL_API=3 etcdctl snapshot status /opt/snapshot-01.db 2>/dev/null')
expect "스냅샷 status 정상 (유효한 etcd 스냅샷)" test -n "$STATUS"
expect "etcd-status.txt 존재 & 비어있지 않음" test -s "$OUT/etcd-status.txt"
q_end; report
