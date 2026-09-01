#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0017
ns_delete checkout
rm -f "$STATE/checkout-uid"
