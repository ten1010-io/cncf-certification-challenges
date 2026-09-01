#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0012
ns_delete shop-gw
