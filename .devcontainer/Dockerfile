# Codespaces 이미지. features 대신 바이너리 직접 설치 → 빌드 시간 단축. docker-in-docker 만 feature 로 유지.
FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

RUN apt-get update \
 && apt-get install -y --no-install-recommends python3 jq bash-completion \
 && rm -rf /var/lib/apt/lists/*

RUN ARCH=$(dpkg --print-architecture) \
 && KUBECTL_VERSION=$(curl -fsSL https://dl.k8s.io/release/stable.txt) \
 && curl -fsSLo /usr/local/bin/kubectl "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${ARCH}/kubectl" \
 && curl -fsSLo /usr/local/bin/kind "https://kind.sigs.k8s.io/dl/latest/kind-linux-${ARCH}" \
 && chmod +x /usr/local/bin/kubectl /usr/local/bin/kind \
 && curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash \
 && kubectl version --client && kind version && helm version
