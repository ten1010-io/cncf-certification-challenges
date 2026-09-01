#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0022
$K -n default delete shirt blue-shirt --ignore-not-found >/dev/null 2>&1
$K delete crd shirts.stable.example.com --ignore-not-found >/dev/null 2>&1
rm -f "$OUT/crds.txt"
