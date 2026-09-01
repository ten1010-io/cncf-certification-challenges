#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0001
ns_delete ci
