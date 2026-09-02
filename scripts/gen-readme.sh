#!/usr/bin/env bash
# info.yml 들을 읽어 (1) 각 문제 README 의 헤더/푸터 블록, (2) 루트 README.md 를 생성한다.
# type-challenges 의 scripts/readme.ts 와 같은 역할. push 마다 GitHub Action 이 실행.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT/scripts/config.sh"
yml() { grep -E "^$2:" "$1" 2>/dev/null | head -1 | sed -E "s/^$2:[[:space:]]*//; s/^[\"']//; s/[\"']$//"; }
urlenc() { python3 -c 'import sys,urllib.parse;print(urllib.parse.quote(sys.argv[1]))' "$1"; }

color_diff() { case "$1" in easy) echo 7aad0c;; medium) echo d9901a;; hard) echo de3d37;; *) echo 999;; esac; }
badge() { echo "<img src=\"https://img.shields.io/badge/-$(urlenc "$1")-$2\" alt=\"$1\"/>"; }

cert_name() { case "$1" in cka) echo "CKA — Certified Kubernetes Administrator";; ckad) echo "CKAD — Certified Kubernetes Application Developer";; cks) echo "CKS — Certified Kubernetes Security Specialist";; *) echo "$1";; esac; }
domain_name() { case "$1" in
  troubleshooting) echo "Troubleshooting";; cluster) echo "Cluster Architecture, Installation & Configuration";; networking) echo "Services & Networking";;
  workloads) echo "Workloads & Scheduling";; storage) echo "Storage";;
  design) echo "Application Design and Build";; deployment) echo "Application Deployment";; observability) echo "Application Observability and Maintenance";; environment) echo "Application Environment, Configuration and Security";;
  *) echo "$1";; esac; }
DOMAIN_ORDER_cka="troubleshooting cluster networking workloads storage"
DOMAIN_ORDER_ckad="environment design deployment networking observability"

# ---- 1) 문제 README 헤더/푸터
for info in "$ROOT"/*/questions/*/info.yml; do
  d=$(dirname "$info"); id=$(printf '%04d' "$(yml "$info" id)"); title=$(yml "$info" title)
  diff=$(yml "$info" difficulty); dom=$(yml "$info" domain); pts=$(yml "$info" points); cert=$(yml "$info" cert)
  tags=$(yml "$info" tags | tr -d '[]' | tr ',' '\n' | sed 's/^ *//;s/ *$//' | grep . || true)
  rel="${d#$ROOT/}"
  header="<!--info-header-start--><h1>$title $(badge "$diff" "$(color_diff "$diff")") $(badge "#$dom" 999)"
  for t in $tags; do header+=" $(badge "#$t" 999)"; done
  header+=" $(badge "${pts}pt" 2b7bb9)</h1>"
  header+="<p><a href=\"https://codespaces.new/$REPO?quickstart=1\" target=\"_blank\"><img src=\"https://img.shields.io/badge/-Open%20in%20Codespaces-24292f?logo=github\" alt=\"Open in Codespaces\"/></a> "
  header+="<a href=\"https://github.com/$REPO/issues/new?title=$(urlenc "$id - $title")&labels=$(urlenc "answer,$cert,$id")&template=answer.yml\" target=\"_blank\"><img src=\"https://img.shields.io/badge/-Share%20your%20Solution-teal\" alt=\"Share your Solution\"/></a> "
  header+="<a href=\"https://github.com/$REPO/issues?q=label%3Aanswer+label%3A$id\" target=\"_blank\"><img src=\"https://img.shields.io/badge/-Check%20out%20Solutions-de5a77\" alt=\"Check out Solutions\"/></a></p><!--info-header-end-->"
  footer="<!--info-footer-start--><br><a href=\"../../../README.md\"><img src=\"https://img.shields.io/badge/-Back-grey\" alt=\"Back\"/></a> <a href=\"./solution.md\"><img src=\"https://img.shields.io/badge/-Solution%20(spoiler)-red\" alt=\"Solution\"/></a> <a href=\"https://github.com/$REPO/edit/$BRANCH/$rel/README.md\"><img src=\"https://img.shields.io/badge/-Edit-blue\" alt=\"Edit\"/></a><!--info-footer-end-->"
  body=$(python3 "$ROOT/scripts/strip-markers.py" "$d/README.md")
  printf '%s\n\n%s\n\n%s\n' "$header" "$body" "$footer" > "$d/README.md"
done

# ---- 2) 루트 README
gen_cert_section() { # <cert>
  local cert="$1" dom order
  order=$(eval echo "\$DOMAIN_ORDER_$1")
  echo "## $(cert_name "$cert")"; echo
  echo "노트: [\`$cert/notes/\`]($cert/notes/) · 모의고사: $(for e in "$ROOT/$cert"/exams/*.yml; do [[ -f "$e" ]] && printf '[%s](%s) ' "$(basename "$e" .yml)" "$cert/exams/$(basename "$e")"; done)"; echo
  for dom in $order; do
    local rows=""; local cnt=0
    for info in "$ROOT/$cert"/questions/*/info.yml; do
      [[ -f "$info" && "$(yml "$info" domain)" == "$dom" ]] || continue
      local id diff title pts rel
      id=$(printf '%04d' "$(yml "$info" id)"); diff=$(yml "$info" difficulty); title=$(yml "$info" title); pts=$(yml "$info" points); rel="${info#$ROOT/}"; rel="${rel%/info.yml}"
      rows+="<a href=\"./$rel/README.md\"><img src=\"https://img.shields.io/badge/$id-$(urlenc "$title" | sed 's/-/--/g')-$(color_diff "$diff")\" alt=\"$id $title\"/></a> "
      cnt=$((cnt+1))
    done
    [[ $cnt -gt 0 ]] || continue
    echo "### $(domain_name "$dom")"; echo; echo "$rows"; echo
  done
}
gen_readme() { # gen_readme <lang> <outfile>
  {
    cat "$ROOT/scripts/templates/README.$1.head.md"
    for cert in cka ckad cks; do [[ -d "$ROOT/$cert/questions" ]] && ls "$ROOT/$cert"/questions/*/info.yml >/dev/null 2>&1 && gen_cert_section "$cert"; done
    cat "$ROOT/scripts/templates/README.$1.tail.md"
  } | sed "s#{{REPO}}#$REPO#g" > "$ROOT/$2"
}
gen_readme en README.md
gen_readme ko README.ko.md
echo "README 생성 완료: $(ls "$ROOT"/*/questions/*/info.yml 2>/dev/null | wc -l | tr -d ' ')문항 (README.md, README.ko.md)"
