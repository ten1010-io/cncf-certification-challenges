#!/usr/bin/env bash
# 문제 setup/check/cleanup 스크립트가 source 하는 공용 라이브러리.
#   source "$(dirname "$0")/../../../common/setup/lib.sh"
# 제공: 클러스터 상수, 노드 명령 실행, 채점 함수, 상태/출력 디렉토리.

CLUSTER="${CLUSTER:-cka}"
CTX="kind-$CLUSTER"
CP_NODE="${CLUSTER}-control-plane"
W1="${CLUSTER}-worker"
W2="${CLUSTER}-worker2"
K="kubectl --context=$CTX"

# 사용자가 결과 파일을 저장하는 곳 (문제 지문에 명시). 문제 상태 저장(uid 등)은 STATE.
OUT="${CNCF_OUT:-/tmp/cncf-out}"
STATE_ROOT="${CNCF_STATE:-/tmp/cncf-state}"
# 각 문제 스크립트는 QID 를 설정한 뒤 lib 를 source 하거나, q_init <id> 를 호출.
q_init() { QID="$1"; STATE="$STATE_ROOT/$QID"; mkdir -p "$OUT" "$STATE"; }

# ---- 노드 명령 (시험의 ssh node01 ↔ 여기서는 docker exec)
node_exec() { local node="$1"; shift; docker exec "$node" "$@"; }
node_sh()   { local node="$1"; shift; docker exec "$node" bash -c "$*"; }

# ---- kubectl 편의
jp() { $K -n "$1" get "$2" -o jsonpath="$3" 2>/dev/null; }          # jp <ns> <kind/name> <jsonpath>
cjp() { $K get "$1" -o jsonpath="$2" 2>/dev/null; }                 # 클러스터 리소스
ns_ensure() { for ns in "$@"; do $K create ns "$ns" --dry-run=client -o yaml | $K apply -f - >/dev/null; done; }
ns_delete() { $K delete ns "$@" --ignore-not-found --wait=false >/dev/null 2>&1 || true; }
wait_ready_pod() { $K -n "$1" wait --for=condition=Ready "pod/$2" --timeout="${3:-180s}" >/dev/null; }
wait_deploy() { $K -n "$1" rollout status "deploy/$2" --timeout="${3:-180s}" >/dev/null; }

# ---- 채점용 클라이언트 파드 (기능 테스트에서 curl/nslookup 실행)
TOOLS_NS="cncf-tools"
client_ensure() {
  ns_ensure "$TOOLS_NS"
  if ! $K -n "$TOOLS_NS" get po chk-client >/dev/null 2>&1; then
    $K -n "$TOOLS_NS" run chk-client --image=busybox:1.36 --labels=app=chk-client --command -- sleep 360000 >/dev/null 2>&1 || true
  fi
  wait_ready_pod "$TOOLS_NS" chk-client 120s 2>/dev/null || true
}
client_exec() { $K -n "$TOOLS_NS" exec chk-client -- "$@" 2>/dev/null; }   # client_exec wget -qO- -T 3 http://IP
http_ok()  { client_exec wget -qO- -T 3 "$1" 2>/dev/null | grep -q "${2:-.}"; }     # http_ok <url> [grep]
http_blocked() { ! client_exec wget -qO- -T 3 "$1" 2>/dev/null | grep -q "${2:-.}"; }

# ---- 채점 프레임워크
TOTAL=0; SCORE=0; RESULTS=()
q_start() { CUR_Q="$1"; CUR_PTS="$2"; CUR_TITLE="$3"; CUR_OK=1; CUR_MSG=(); TOTAL=$((TOTAL + CUR_PTS)); }
expect() { local d="$1"; shift; if "$@" >/dev/null 2>&1; then CUR_MSG+=("    ✔ $d"); else CUR_MSG+=("    ✘ $d"); CUR_OK=0; fi; }
expect_eq() { if [[ "$2" == "$3" ]]; then CUR_MSG+=("    ✔ $1"); else CUR_MSG+=("    ✘ $1 (기대: '$2', 실제: '$3')"); CUR_OK=0; fi; }
expect_ne() { if [[ "$2" != "$3" ]]; then CUR_MSG+=("    ✔ $1"); else CUR_MSG+=("    ✘ $1 (금지값: '$2')"); CUR_OK=0; fi; }
expect_contains() { if [[ "$3" == *"$2"* ]]; then CUR_MSG+=("    ✔ $1"); else CUR_MSG+=("    ✘ $1 ('$2' 없음)"); CUR_OK=0; fi; }
expect_not_contains() { if [[ "$3" != *"$2"* ]]; then CUR_MSG+=("    ✔ $1"); else CUR_MSG+=("    ✘ $1 ('$2' 포함됨)"); CUR_OK=0; fi; }
expect_ge() { if [[ "${3:-0}" -ge "$2" ]] 2>/dev/null; then CUR_MSG+=("    ✔ $1"); else CUR_MSG+=("    ✘ $1 (기대 >= $2, 실제 '${3:-}')"); CUR_OK=0; fi; }
info() { CUR_MSG+=("    ℹ $1"); }
q_end() {
  local mark="FAIL"; [[ $CUR_OK -eq 1 ]] && { SCORE=$((SCORE + CUR_PTS)); mark="PASS"; }
  RESULTS+=("[$mark] $CUR_Q (${CUR_PTS}pt) $CUR_TITLE"); for m in "${CUR_MSG[@]}"; do RESULTS+=("$m"); done
  # 기계 판독용 한 줄 (bin/q exam check 가 집계)
  echo "RESULT $CUR_Q $([[ $mark == PASS ]] && echo "$CUR_PTS" || echo 0) $CUR_PTS $mark"
}
report() { for r in "${RESULTS[@]}"; do echo "$r"; done; }
