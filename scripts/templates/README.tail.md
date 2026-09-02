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
| kubeadm 업그레이드·etcd 복원 실습 | kind 에서 위험 → 명령 시퀀스 작성형 문제로 대체 |

## 로컬 실행 (크레딧 없이 무제한)

Codespaces 와 동일한 kind 클러스터를 로컬 Docker 에 만든다. minikube 는 노드명·인증서 경로·포트가 달라 일부 문제와 어긋나므로 kind 권장.

```bash
brew install kind kubectl helm            # Docker Desktop: Memory 8GB, CPU 4 이상
git clone https://github.com/{{REPO}}.git && cd $(basename {{REPO}})
export PATH="$PATH:$PWD/bin"; alias k=kubectl
q cluster up                              # 첫 5분
q start 1
```

문제별 환경은 `<cert>/questions/NNNN-*/setup.sh`, 채점 기준은 같은 폴더 `check.sh`, 클러스터 구성은 `common/setup/`.

## Codespaces 속도

첫 생성은 이미지 빌드(docker-in-docker + kubectl/kind/helm) 2~4분 + `q cluster up` 3~5분. 팀 저장소면 **Settings → Codespaces → Set up prebuild** (branch `main`, region 가까운 곳) 를 켜두면 빌드 단계가 사라져 수십 초에 열린다. Codespace 는 정지해도 디스크가 남으므로 두 번째부터는 클러스터도 대개 살아 있다.

## 기여

풀이 공유 = Issue, 문제 추가 = **Add a Question** 이슈 폼(봇이 PR 생성, `approved` 라벨로 머지) 또는 직접 PR. 규약은 [CONTRIBUTING.md](CONTRIBUTING.md).

## License

[MIT](LICENSE)
