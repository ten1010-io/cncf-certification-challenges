#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0014
node_exec "$W2" systemctl enable --now kubelet >/dev/null 2>&1 || true
