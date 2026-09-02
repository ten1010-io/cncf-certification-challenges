#!/usr/bin/env bash
# Codespace 시작마다 실행. 클러스터를 백그라운드로 준비해 사용자가 문제 읽는 동안 끝나게 한다.
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
LOG=/tmp/cncf-cluster.log
if kind get clusters 2>/dev/null | grep -qx cka && docker ps --format '{{.Names}}' | grep -q '^cka-control-plane$'; then
  echo "cluster already up" > "$LOG"
else
  nohup bash -c "cd '$ROOT' && ./bin/q cluster up" > "$LOG" 2>&1 &
fi
