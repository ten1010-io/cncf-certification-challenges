#!/usr/bin/env bash
# 컨테이너 생성 직후 1회. 셸 편의 설정.
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cat >> ~/.bashrc <<B
alias k=kubectl
export PATH="\$PATH:$ROOT/bin"
source <(kubectl completion bash) 2>/dev/null; complete -o default -F __start_kubectl k 2>/dev/null
export do="--dry-run=client -o yaml"
B
echo "post-create done"
