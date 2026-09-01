# 시험 전략과 환경 (CKA·CKAD·CKS 공통)

## 시험 환경

- PSI Bridge + PSI Secure Browser. 원격 데스크톱(XFCE) 안에 터미널 + Firefox(문서 전용).
- 단일 모니터, 웹캠, 마이크, 조용한 방. 책상 위 비우기. 시험 전 방 360도 촬영 요구.
- 문제마다 `kubectl config use-context <name>` 명령이 문제 상단에 제시됨. **반드시 먼저 실행.**
- 일부 문제는 `ssh <node>`로 노드 진입 필요. 작업 끝나면 `exit`로 돌아오기. 노드 안에서 다음 문제 풀면 안 됨.
- `k` alias는 기본 제공. 그 외 alias/설정은 문제 간 유지 안 됨(다른 클러스터).
- 복사: `Ctrl+Shift+C`, 붙이기: `Ctrl+Shift+V`. 마우스 우클릭 붙이기 불안정.
- 허용 URL: `kubernetes.io/docs`, `kubernetes.io/blog`, `github.com/kubernetes`, `helm.sh/docs`(Helm 문제 시), Gateway API 문서(`gateway-api.sigs.k8s.io`). 나머지 탭 열면 경고.
- 노트패드 기능 있음. 문제 번호별 완료 여부 메모용.

## 시간 배분 (120분, 15~20문항)

| 구간 | 행동 |
|---|---|
| 0~5분 | 전체 문제 스캔. 배점(%) 확인. 쉬움/어려움 표시 |
| 5~80분 | 1차 패스: 쉬운 것, 배점 높은 것 먼저. 5분 넘게 막히면 스킵 후 표시 |
| 80~110분 | 2차 패스: 스킵한 문제 |
| 110~120분 | 검증. `k get` 으로 요구 이름/네임스페이스/라벨 재확인 |

- 부분 점수 있음. 완벽하지 않아도 저장하고 넘기기.
- 문제에서 요구한 **정확한 이름, 네임스페이스, 라벨, 파일 경로** 가 채점 기준. 오타 = 0점.
- 트러블슈팅 문제(30%)는 시간 먹는 블랙홀. 1차 패스에서 5분 룰 엄수.

## 첫 60초 세팅

```bash
# 시험 환경 기본 제공. 필요 시 확인만.
alias k=kubectl
export do="--dry-run=client -o yaml"
export now="--force --grace-period=0"
# 예: k run nginx --image=nginx $do > pod.yaml
# 예: k delete pod nginx $now
```

vim 설정(노드 진입 시마다 사라짐, 필요할 때만):

```bash
cat >> ~/.vimrc <<'V'
set ts=2 sw=2 et ai nu
V
```

## 문서 북마크 (자주 여는 페이지)

시험 중 검색보다 빠름. 페이지 제목 기억해두기.

| 주제 | 문서 페이지 |
|---|---|
| etcd 백업/복원 | Operating etcd clusters for Kubernetes |
| kubeadm 업그레이드 | Upgrading kubeadm clusters |
| RBAC | Using RBAC Authorization |
| NetworkPolicy | Network Policies |
| Ingress | Ingress |
| Gateway API | Gateway API (kubernetes.io/docs/concepts/services-networking/gateway/) |
| PV/PVC | Persistent Volumes, Configure a Pod to Use a PersistentVolume for Storage |
| DaemonSet | DaemonSet |
| Static Pod | Create static Pods |
| Init container | Init Containers |
| Probe | Configure Liveness, Readiness and Startup Probes |
| Affinity | Assigning Pods to Nodes |
| Taint | Taints and Tolerations |
| HPA | HorizontalPodAutoscaler Walkthrough |
| Kustomize | Declarative Management of Kubernetes Objects Using Kustomize |
| kubectl 치트시트 | kubectl Quick Reference |

## 실수 방지 체크리스트

- [ ] context 전환했는가
- [ ] 네임스페이스 `-n` 붙였는가 (문제에 ns 없으면 default)
- [ ] 리소스 이름/라벨 오타 없는가
- [ ] 노드 ssh 후 `exit` 했는가
- [ ] 파일 저장 경로가 문제 지정 경로(`/opt/...`)와 일치하는가
- [ ] 수정한 Deployment가 실제 Ready 상태인가 (`k rollout status`)
- [ ] YAML 편집 후 `k apply` / `k replace --force` 실행했는가
