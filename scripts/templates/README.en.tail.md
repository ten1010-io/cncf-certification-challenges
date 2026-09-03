## Run without Codespaces

Codespaces has a monthly free quota. Running locally costs nothing and gives you the exact same cluster, because both use [kind](https://kind.sigs.k8s.io/) (Kubernetes in Docker).

**Requirements**: Docker (Desktop or Engine) with at least 4 CPUs and 8 GB memory allocated. On Docker Desktop that is Settings → Resources.

```bash
# 1. Tools
brew install kind kubectl helm                 # macOS
# Linux: install kind, kubectl, helm from their official docs

# 2. Repository
git clone https://github.com/{{REPO}}.git
cd cncf-certification-challenges
export PATH="$PATH:$PWD/bin"                   # makes `q` available; add to ~/.zshrc or ~/.bashrc
alias k=kubectl

# 3. Cluster (once, 3-5 min: pulls node images, installs Calico, metrics-server, ingress-nginx, Gateway API)
q cluster up

# 4. Solve, exactly like in Codespaces
q list cka
q start 13
q check
q reset            # clean the question's resources when done
```

Stop paying attention to it and it keeps running; `q cluster down` deletes the cluster entirely. Docker restarts the kind containers after a reboot, so the cluster usually survives.

**Why kind and not minikube**: every question assumes kind's node names (`cka-control-plane`, `cka-worker`, `cka-worker2`), kubeadm certificate paths (`/etc/kubernetes/pki/etcd/`), and API server port 6443 - the same layout as the real exam. minikube uses different names, `/var/lib/minikube/certs/`, and port 8443, which breaks the etcd and node-recovery questions. If minikube is your only option, the questions still teach the concepts, but read `common/setup/lib.sh` and adjust node names yourself.

**Where each question's environment lives**

| What | Where |
|---|---|
| Cluster shape (nodes, CNI, add-ons) | `common/setup/kind-config.yaml`, `common/setup/create-cluster.sh` |
| Per-question environment and fault injection | `<cert>/questions/NNNN-*/setup.sh` |
| Grading criteria | `<cert>/questions/NNNN-*/check.sh` |
| Helpers the scripts use (node access, assertions) | `common/setup/lib.sh` |

## Codespaces cost

First launch builds the image (2-4 min) and then the cluster (3-5 min). Turn on **Settings → Codespaces → Set up prebuild** on this repository and the build step disappears.

The free plan gives 120 core-hours per month, which is 30 hours on the 4-core machine this repo requests. To make it last: stop the codespace when you finish (F1 → `Codespaces: Stop Current Codespace`) instead of waiting for the idle timeout, and lower *Default idle timeout* to 15 minutes in your personal Codespaces settings. Stopping keeps the disk, so the cluster is still there when you come back.

## Shared material

- [Exam environment and strategy](common/exam-environment.md) - PSI setup, time budgeting, doc bookmarks, mistake checklist
- [kubectl cheatsheet](common/kubectl-cheatsheet.md)
- [Cluster scripts](common/setup/) - kind 3 nodes + Calico + metrics-server + ingress-nginx + Gateway API

## Differences from the real exam

| Real exam | Here |
|---|---|
| A different cluster per question | One kind cluster; `q exam` provisions every question's environment at once |
| `ssh node01` | `docker exec -it cka-worker bash` |
| Result files under `/opt/...` | `/tmp/cncf-out/...` |
| kubeadm upgrades and etcd restore performed for real | Too destructive for a shared cluster, so those are written-procedure questions |

## Contributing

Solutions go in Issues. New questions go through the **Add a Question** form or a direct PR. See [CONTRIBUTING.md](CONTRIBUTING.md) for the contract and the maintainer workflow.

## License

[MIT](LICENSE)
