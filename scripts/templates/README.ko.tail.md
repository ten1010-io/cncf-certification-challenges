## Codespaces 없이 실행하기

Codespaces 는 월 무료 한도가 있다. 로컬 실행은 비용이 없고 클러스터도 완전히 동일하다. 둘 다 [kind](https://kind.sigs.k8s.io/)(Kubernetes in Docker)를 쓰기 때문이다.

**준비물**: Docker(Desktop 또는 Engine), CPU 4개·메모리 8GB 이상 할당. Docker Desktop 은 Settings → Resources 에서 조정.

```bash
# 1. 도구
brew install kind kubectl helm                 # macOS
# Linux: kind, kubectl, helm 을 각 공식 문서대로 설치

# 2. 저장소
git clone https://github.com/{{REPO}}.git
cd cncf-certification-challenges
export PATH="$PATH:$PWD/bin"                   # q 명령 사용. ~/.zshrc 나 ~/.bashrc 에 넣어두면 편하다
alias k=kubectl

# 3. 클러스터 (최초 1회, 3~5분: 노드 이미지 pull + Calico, metrics-server, ingress-nginx, Gateway API 설치)
q cluster up

# 4. Codespaces 와 완전히 같은 방식으로 풀기
q list cka
q start 13
q check
q reset            # 문제 리소스 정리
```

클러스터는 그냥 두면 계속 살아 있고, `q cluster down` 으로 완전히 지운다. 재부팅해도 Docker 가 kind 컨테이너를 되살리므로 대개 그대로 남는다.

**minikube 가 아니라 kind 인 이유**: 모든 문제가 kind 의 노드 이름(`cka-control-plane`, `cka-worker`, `cka-worker2`), kubeadm 인증서 경로(`/etc/kubernetes/pki/etcd/`), API 서버 6443 포트를 전제로 한다. 실제 시험과 같은 구조다. minikube 는 노드 이름이 다르고 인증서가 `/var/lib/minikube/certs/`, 포트가 8443 이라 etcd·노드 복구 문제가 어긋난다. minikube 밖에 못 쓰는 상황이라면 개념 학습은 되지만 `common/setup/lib.sh` 를 읽고 노드 이름을 직접 맞춰야 한다.

**문제별 환경이 정의된 곳**

| 무엇 | 위치 |
|---|---|
| 클러스터 구성(노드 수, CNI, 애드온) | `common/setup/kind-config.yaml`, `common/setup/create-cluster.sh` |
| 문제별 환경 구성·고장 주입 | `<cert>/questions/NNNN-*/setup.sh` |
| 채점 기준 | `<cert>/questions/NNNN-*/check.sh` |
| 스크립트가 쓰는 헬퍼(노드 접속, 검증 함수) | `common/setup/lib.sh` |

## Codespaces 비용

첫 실행은 이미지 빌드 2~4분 + 클러스터 생성 3~5분. 저장소 **Settings → Codespaces → Set up prebuild** 를 켜면 빌드 단계가 사라진다.

무료 플랜은 월 120 core-hours, 이 저장소가 요구하는 4코어 머신 기준 30시간이다. 아끼려면 다 풀고 나서 idle timeout 을 기다리지 말고 바로 정지하고(F1 → `Codespaces: Stop Current Codespace`), 개인 Codespaces 설정에서 *Default idle timeout* 을 15분으로 낮춘다. 정지해도 디스크는 남아서 다음에 열면 클러스터가 그대로 있다.

## 공통 자료

- [시험 환경·전략](common/exam-environment.md) — PSI 환경, 시간 배분, 문서 북마크, 실수 체크리스트
- [kubectl 치트시트](common/kubectl-cheatsheet.md)
- [클러스터 스크립트](common/setup/) — kind 3노드 + Calico + metrics-server + ingress-nginx + Gateway API

## 실제 시험과의 차이

| 실제 시험 | 여기 |
|---|---|
| 문제마다 다른 클러스터 | 단일 kind 클러스터. `q exam` 은 문항 환경을 한 번에 구성 |
| `ssh node01` | `docker exec -it cka-worker bash` |
| 결과 파일 `/opt/...` | `/tmp/cncf-out/...` |
| kubeadm 업그레이드·etcd 복원을 실제로 수행 | 공유 클러스터에 파괴적이라 절차 작성형 문제로 대체 |

## 기여

풀이 공유 = Issue, 문제 추가 = **Add a Question** 이슈 폼 또는 직접 PR. 규약과 메인테이너 절차는 [CONTRIBUTING.md](CONTRIBUTING.md).

## License

[MIT](LICENSE)
