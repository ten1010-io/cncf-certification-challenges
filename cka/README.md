# CKA — Certified Kubernetes Administrator

기준 커리큘럼: Linux Foundation 2025-02-18 개정판, Kubernetes v1.35. 시험 환경·전략은 [`../common/exam-environment.md`](../common/exam-environment.md).

## 구성

```
cka/
├── notes/         # 도메인별 요점 정리 (5파일)
├── questions/     # 문제 은행. 폴더 하나 = 문제 하나 (README, info.yml, setup, check, cleanup, solution)
├── exams/         # 모의고사 = 문항 id 조합 (exam-01.yml, exam-02.yml)
└── drills/        # 도메인별 단문 연습 + 접힌 정답 (채점 없음)
```

문제 목록과 뱃지는 루트 [README](../README.md) 참고 (자동 생성).

## 도메인 비중

| 도메인 | 비중 | 노트 |
|---|---|---|
| Troubleshooting | 30% | [`notes/05-troubleshooting.md`](notes/05-troubleshooting.md) |
| Cluster Architecture, Installation & Configuration | 25% | [`notes/01-cluster-architecture.md`](notes/01-cluster-architecture.md) |
| Services & Networking | 20% | [`notes/03-services-networking.md`](notes/03-services-networking.md) |
| Workloads & Scheduling | 15% | [`notes/02-workloads-scheduling.md`](notes/02-workloads-scheduling.md) |
| Storage | 10% | [`notes/04-storage.md`](notes/04-storage.md) |

## 추천 학습 순서 (6주)

| 주 | 내용 | 실습 |
|---|---|---|
| 1 | 시험 환경, `notes/02` 워크로드, kubectl 손에 익히기 | `drills/workloads.md`, `q list cka --domain workloads` 문제 전부 |
| 2 | `notes/03` 네트워킹 | `drills/networking.md`, networking 문제 |
| 3 | `notes/04` 스토리지 + `notes/01` RBAC·Helm·Kustomize·CRD | storage/cluster 문제 (easy) |
| 4 | `notes/01` kubeadm·etcd·인증서 | cluster 문제 (medium) |
| 5 | `notes/05` 트러블슈팅 | troubleshooting 문제 전부, `q exam start exam-01` |
| 6 | 반복 + killer.sh 1차 → 복습 → killer.sh 2차 → 실전 | `exam-02`, killer.sh |

## 실행

```bash
./bin/q cluster up                   # kind 3노드 (한 번만)
./bin/q list cka                     # 문제 목록
./bin/q start 0013 && ./bin/q check 0013
./bin/q exam start exam-01           # 17문항 2시간
./bin/q exam check exam-01
```
