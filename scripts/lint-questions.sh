#!/usr/bin/env bash
# 문제 폴더 규약 검사. CI(verify-question.yml) 와 로컬에서 사용.
set -uo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
yml() { grep -E "^$2:" "$1" 2>/dev/null | head -1 | sed -E "s/^$2:[[:space:]]*//"; }
fail=0; err() { echo "✘ $1"; fail=1; }
seen_ids=""
for d in "$ROOT"/*/questions/*/; do
  d="${d%/}"; name=$(basename "$d"); cert=$(basename "$(dirname "$(dirname "$d")")")
  [[ "$name" =~ ^[0-9]{4}-(easy|medium|hard)-[a-z0-9-]+$ ]] || err "$name: 폴더명 형식 NNNN-<difficulty>-<slug>"
  for f in README.md info.yml setup.sh check.sh cleanup.sh solution.md; do [[ -f "$d/$f" ]] || err "$name: $f 없음"; done
  for f in setup.sh check.sh cleanup.sh; do [[ -f "$d/$f" ]] && { bash -n "$d/$f" || err "$name: $f 문법 오류"; [[ -x "$d/$f" ]] || err "$name: $f 실행 권한 없음"; }; done
  [[ -f "$d/info.yml" ]] || continue
  id=$(yml "$d/info.yml" id); [[ "$(printf '%04d' "${id:-0}")" == "${name:0:4}" ]] || err "$name: info.yml id($id) 와 폴더 번호 불일치"
  grep -qw "$id" <<<"$seen_ids" && err "$name: id $id 중복"; seen_ids="$seen_ids $id"
  [[ "$(yml "$d/info.yml" difficulty)" == "$(cut -d- -f2 <<<"$name")" ]] || err "$name: difficulty 와 폴더명 불일치"
  [[ "$(yml "$d/info.yml" cert)" == "$cert" ]] || err "$name: cert 가 $cert 아님"
  for k in title domain points; do [[ -n "$(yml "$d/info.yml" $k)" ]] || err "$name: info.yml $k 없음"; done
  grep -q "q_init ${name:0:4}" "$d/setup.sh" "$d/check.sh" "$d/cleanup.sh" 2>/dev/null || err "$name: 스크립트에 q_init ${name:0:4} 없음"
  grep -q '^q_start ' "$d/check.sh" && grep -q '^q_end' "$d/check.sh" || err "$name: check.sh 에 q_start/q_end 없음"
  grep -q '<!--info-header-start-->' "$d/README.md" || err "$name: README 헤더 블록 없음 (scripts/gen-readme.sh 실행)"
done
for e in "$ROOT"/*/exams/*.yml; do
  [[ -f "$e" ]] || continue
  for id in $(sed -n '/^questions:/,$p' "$e" | grep -E '^[[:space:]]*-[[:space:]]*[0-9]+' | sed -E 's/^[[:space:]]*-[[:space:]]*([0-9]+).*/\1/'); do
    ls -d "$ROOT"/*/questions/"$id"-* >/dev/null 2>&1 || err "$(basename "$e"): 문항 $id 없음"
  done
done
[[ $fail -eq 0 ]] && echo "✔ lint OK ($(ls -d "$ROOT"/*/questions/*/ | wc -l | tr -d ' ')문항)"
exit $fail
