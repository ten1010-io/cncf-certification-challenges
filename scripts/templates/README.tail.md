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

## 기여

문제 추가는 PR, 풀이 공유는 Issue. 규약은 [CONTRIBUTING.md](CONTRIBUTING.md). 새 문제 폴더: `<cert>/questions/NNNN-<difficulty>-<slug>/{README.md,info.yml,setup.sh,check.sh,cleanup.sh,solution.md}`.

## License

[MIT](LICENSE)
