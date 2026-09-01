#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0020
command -v helm >/dev/null 2>&1 || { echo "ERROR: helm 이 필요하다 (brew install helm). 문제 0020 setup 중단." >&2; exit 1; }
rm -rf "$STATE/webapp" "$OUT/charts"
rm -f "$OUT/helm-history.txt"
mkdir -p "$OUT/charts"
echo "==> helm 차트 webapp 패키징 (0.1.0, 0.2.0) -> $OUT/charts/"
(cd "$STATE" && helm create webapp >/dev/null)
sed -i.bak 's/^version: .*/version: 0.1.0/' "$STATE/webapp/Chart.yaml"
(cd "$OUT/charts" && helm package "$STATE/webapp" >/dev/null)
sed -i.bak 's/^version: .*/version: 0.2.0/' "$STATE/webapp/Chart.yaml"
(cd "$OUT/charts" && helm package "$STATE/webapp" >/dev/null)
rm -f "$STATE/webapp/Chart.yaml.bak"
ls "$OUT/charts"
