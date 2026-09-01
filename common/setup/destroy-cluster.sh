#!/usr/bin/env bash
set -euo pipefail
CLUSTER="${CLUSTER:-cka}"
kind delete cluster --name "$CLUSTER"
rm -rf /tmp/cncf-out /tmp/cncf-state
