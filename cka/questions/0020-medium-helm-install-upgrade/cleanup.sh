#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0020
helm --kube-context "$CTX" uninstall shop-web -n helm-shop >/dev/null 2>&1
ns_delete helm-shop
rm -rf "$OUT/charts" "$STATE/webapp"
rm -f "$OUT/helm-history.txt"
