#!/usr/bin/env bash
# 터미널이 붙을 때마다 상태 배너.
LOG=/tmp/cncf-cluster.log
echo "┌─ cncf-certification ─────────────────────────────────────────"
if kubectl --context kind-cka get no >/dev/null 2>&1; then
  echo "│ 클러스터: READY  ($(kubectl --context kind-cka get no --no-headers 2>/dev/null | awk '{print $2}' | sort | uniq -c | awk '{printf "%s %s ", $1, $2}'))"
else
  echo "│ 클러스터: 준비 중... (3~5분)   진행 로그: tail -f $LOG"
fi
echo "│"
echo "│   q list                문제 목록"
echo "│   q start 13            문제 시작 (환경 구성 + 지문 출력)"
echo "│   q check               현재 문제 채점       q solution   풀이"
echo "│   q exam start exam-01  모의고사"
echo "└──────────────────────────────────────────────────────────────"
