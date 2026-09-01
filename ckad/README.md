# CKAD — Certified Kubernetes Application Developer

기준 커리큘럼: Linux Foundation CKAD (Kubernetes v1.35 환경). 시험 형식·환경은 `../common/exam-environment.md` 와 동일 (2h, 15~20문항, 66%).
CKA 와 겹치는 영역이 많아 `../cka/notes/` 를 재사용하고, CKAD 고유 영역만 `notes/` 에 추가한다.

## 구성

```
ckad/
├── notes/         # CKAD 고유 요점 정리 (작성 예정, 아래 목록)
├── questions/     # 문제 은행 (작성 예정). 폴더 규약은 cka/questions 와 동일, 번호는 전역 유일 (0035~)
└── exams/         # 모의고사 = 문항 id 조합
```

## 도메인 비중

| 도메인 | 비중 | 핵심 주제 | 재사용 가능한 CKA 노트 |
|---|---|---|---|
| Application Environment, Configuration and Security | 25% | CRD/Operator 발견·사용, 인증/인가(RBAC, SA), ResourceQuota/LimitRange, ConfigMap/Secret, SecurityContext(runAsUser, capabilities, readOnlyRootFilesystem) | `cka/notes/01` RBAC·CRD, `cka/notes/02` CM/Secret |
| Application Design and Build | 20% | 컨테이너 이미지 정의·빌드·수정, Job/CronJob, 멀티컨테이너 패턴(sidecar, init, ambassador, adapter), PV/PVC/emptyDir | `cka/notes/02` 워크로드, `cka/notes/04` 스토리지 |
| Application Deployment | 20% | Deployment 롤링업데이트/롤백, 배포 전략(blue/green, canary), Helm 으로 패키지 설치, Kustomize | `cka/notes/02` Deployment, `cka/notes/01` Helm/Kustomize |
| Services and Networking | 20% | Service 타입, NetworkPolicy, Ingress, (Gateway API) | `cka/notes/03` 그대로 |
| Application Observability and Maintenance | 15% | API deprecation 대응, probe(liveness/readiness/startup), `kubectl logs`·`top`·`describe`·`events` 로 디버깅, 모니터링 | `cka/notes/05` Pod 상태표·로그 |

CKA 에만 있고 CKAD 에 없는 것: kubeadm 설치/업그레이드, etcd 백업/복원, 노드/컨트롤플레인 트러블슈팅, 인증서 관리, CNI/CSI/CRI. CKAD 준비 시 `cka/notes/01` 의 kubeadm·etcd 절과 `cka/notes/05` 의 노드/컨트롤플레인 절은 건너뛴다.

## CKAD 고유 노트 (작성 예정)

| 파일 | 내용 |
|---|---|
| `notes/01-app-design-build.md` | Dockerfile/이미지 빌드(`docker build`, `podman`), 이미지 태그·레지스트리, 멀티컨테이너 패턴 4종 YAML, init container 순서, Job 병렬/완료 패턴 |
| `notes/02-app-deployment.md` | 배포 전략 구현법(Deployment 2개+Service selector 스위치 = blue/green, replicas 비율 = canary), `kubectl rollout` 전부, Helm `install/upgrade/rollback/template`, Kustomize overlay |
| `notes/03-observability.md` | probe 3종 파라미터 튜닝, `kubectl logs -c/--previous/--since`, `kubectl debug` ephemeral container, `kubectl top`, API deprecation 확인(`kubectl api-versions`, `kubectl convert`) |
| `notes/04-env-config-security.md` | SecurityContext Pod/컨테이너 레벨 차이, capabilities, seccomp, ServiceAccount 토큰 마운트, RBAC 최소권한, ResourceQuota/LimitRange 계산, CRD 탐색(`kubectl explain`, `api-resources`) |
| `notes/05-services-networking.md` | CKA `notes/03` 링크 + CKAD 시험에서 자주 쓰는 `kubectl expose`/`create ingress` 명령 모음 |

## 문제 (작성 예정)

`../cka/questions/` 와 같은 폴더 규약([CONTRIBUTING](../CONTRIBUTING.md)). `info.yml` 의 `cert: ckad`, `domain` 은 `environment | design | deployment | networking | observability`. 클러스터·채점 함수는 `../common/setup/` 공용. CKA 와 겹치는 문항(예: 0002 Deployment+NodePort, 0010 NetworkPolicy)은 `exams/*.yml` 에서 id 만 참조해 재사용한다.

CKAD 문제 유형 예시:
- Dockerfile 주어짐 → 이미지 빌드해 `image.tar` 로 저장
- Deployment 를 canary 로 10% 트래픽 분배 (replicas 9:1 + 공통 라벨 Service)
- Pod 에 `runAsUser: 1000`, `allowPrivilegeEscalation: false`, `capabilities: {add: [NET_ADMIN]}` 적용
- 기존 Deployment 의 API 버전 deprecated → 최신 apiVersion 으로 변환 후 재배포
- CronJob 이 실패 시 3회 재시도, 동시 실행 금지, 40초 지나면 시작 안 함
- 특정 Pod 로그에서 에러 라인 추출, 재시작 원인을 `describe` 로 찾아 수정
- ResourceQuota 걸린 ns 에 Pod 생성 안 되는 원인 수정

## 추천 학습 순서 (4주)

| 주 | 내용 |
|---|---|
| 1 | `common/exam-environment.md`, `cka/notes/02` 워크로드, `cka/drills/workloads.md` |
| 2 | `cka/notes/03` 네트워킹, `cka/notes/04` 스토리지, drills networking/storage |
| 3 | CKAD 고유: 배포 전략, SecurityContext, Helm/Kustomize, probe 튜닝 |
| 4 | 모의고사 + killer.sh (CKAD 시뮬레이터) 2회 |

## 참고

- 공식: https://training.linuxfoundation.org/certification/certified-kubernetes-application-developer-ckad/
- 커리큘럼 저장소: https://github.com/cncf/curriculum
- 연습: https://github.com/dgkanatsios/CKAD-exercises , killercoda CKAD 시나리오
