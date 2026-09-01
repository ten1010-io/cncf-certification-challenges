#!/usr/bin/env bash
# 실습/모의고사용 kind 클러스터 생성.
#   노드: cka-control-plane, cka-worker, cka-worker2   (실제 시험의 cp01 / node01 / node02 역할)
#   설치: Calico(NetworkPolicy), metrics-server, ingress-nginx, Gateway API CRD, 노드에 etcdctl/etcdutl
# 요구: docker, kind, kubectl. Codespaces(.devcontainer) 또는 로컬 Docker(메모리 8GB 권장).
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

CLUSTER="${CLUSTER:-cka}"
K8S_VERSION="${K8S_VERSION:-v1.35.0}"
CALICO_VERSION="${CALICO_VERSION:-v3.30.2}"
INGRESS_NGINX_VERSION="${INGRESS_NGINX_VERSION:-controller-v1.13.0}"
METRICS_SERVER_VERSION="${METRICS_SERVER_VERSION:-v0.7.2}"
GATEWAY_API_VERSION="${GATEWAY_API_VERSION:-v1.3.0}"

if kind get clusters 2>/dev/null | grep -qx "$CLUSTER"; then
  echo "kind 클러스터 '$CLUSTER' 이미 존재. 재생성하려면: bash common/setup/destroy-cluster.sh"
  exit 0
fi

echo "==> kind create cluster ($CLUSTER, $K8S_VERSION)"
kind create cluster --config "$HERE/kind-config.yaml" --image "kindest/node:$K8S_VERSION" --wait 120s
kubectl config use-context "kind-$CLUSTER" >/dev/null

echo "==> Calico $CALICO_VERSION"
kubectl apply -f "https://raw.githubusercontent.com/projectcalico/calico/$CALICO_VERSION/manifests/calico.yaml"

echo "==> metrics-server $METRICS_SERVER_VERSION"
kubectl apply -f "https://github.com/kubernetes-sigs/metrics-server/releases/download/$METRICS_SERVER_VERSION/components.yaml"
kubectl -n kube-system patch deploy metrics-server --type=json \
  -p='[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]'

echo "==> ingress-nginx $INGRESS_NGINX_VERSION"
kubectl apply -f "https://raw.githubusercontent.com/kubernetes/ingress-nginx/$INGRESS_NGINX_VERSION/deploy/static/provider/kind/deploy.yaml"

echo "==> Gateway API CRDs $GATEWAY_API_VERSION (standard)"
kubectl apply -f "https://github.com/kubernetes-sigs/gateway-api/releases/download/$GATEWAY_API_VERSION/standard-install.yaml"

echo "==> 노드 Ready 대기"
kubectl wait --for=condition=Ready node --all --timeout=300s
kubectl -n kube-system rollout status ds/calico-node --timeout=300s
kubectl -n kube-system rollout status deploy/coredns --timeout=180s
kubectl -n kube-system rollout status deploy/metrics-server --timeout=180s || echo "WARN: metrics-server 미준비 (나중에 확인)"
kubectl -n ingress-nginx rollout status deploy/ingress-nginx-controller --timeout=180s || echo "WARN: ingress-nginx 미준비"

echo "==> control-plane 노드에 etcdctl/etcdutl 설치 (실제 시험 환경과 동일하게)"
ETCD_TAG=$(kubectl -n kube-system get po "etcd-${CLUSTER}-control-plane" -o jsonpath='{.spec.containers[0].image}' | sed -E 's/.*:([0-9]+\.[0-9]+\.[0-9]+).*/\1/')
ARCH=$(docker exec "${CLUSTER}-control-plane" uname -m); case "$ARCH" in aarch64) ARCH=arm64;; x86_64) ARCH=amd64;; esac
if docker exec "${CLUSTER}-control-plane" bash -c "curl -fsSL https://github.com/etcd-io/etcd/releases/download/v${ETCD_TAG}/etcd-v${ETCD_TAG}-linux-${ARCH}.tar.gz | tar xz -C /usr/local/bin --strip-components=1 etcd-v${ETCD_TAG}-linux-${ARCH}/etcdctl etcd-v${ETCD_TAG}-linux-${ARCH}/etcdutl"; then
  echo "    etcdctl v${ETCD_TAG} 설치됨"
else
  echo "WARN: etcdctl 다운로드 실패. 문제에서 'etcd Pod 안에서 kubectl exec' 대안 사용."
fi

cat <<MSG

클러스터 준비 완료.

  context:        kind-$CLUSTER
  노드:           $(kubectl get no -o name | sed 's#node/##' | tr '\n' ' ')
  노드 접속:      docker exec -it ${CLUSTER}-worker bash      (시험의 'ssh node01' 에 해당)
  control-plane:  docker exec -it ${CLUSTER}-control-plane bash
  ingress:        http://localhost:8080  (Host 헤더 필요)

다음:  ./bin/q list          문제 목록
       ./bin/q start 0001    문제 시작
MSG
