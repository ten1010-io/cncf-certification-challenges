# Contributing

풀이 공유는 **Issue**, 문제·노트·도구 추가는 **PR**.

## 풀이 공유 (Issue)

문제 README 상단 **Share your Solution** 클릭 → 제목·라벨이 채워진 이슈 폼. 명령·YAML·`q check` 출력·소요 시간·함정을 적는다.
다른 사람 풀이는 **Check out Solutions** (`label:answer label:NNNN`).

## 문제 추가 (PR)

### 폴더

```
<cert>/questions/NNNN-<difficulty>-<slug>/
├── README.md      # 지문. 헤더/푸터는 scripts/gen-readme.sh 가 생성 (마커 사이는 건드리지 않음)
├── info.yml       # 메타데이터
├── setup.sh       # 환경 구성. 멱등. 자기 리소스만 만들고 필요하면 고장 주입
├── check.sh       # 채점. q_start → expect* → q_end 로 RESULT 한 줄 출력
├── cleanup.sh     # 환경 제거
└── solution.md    # 풀이 + 함정 설명
```

- `NNNN`: 다음 빈 번호 (`./bin/q list` 로 확인). 자격증 간 번호 공유 (전역 유일).
- `difficulty`: easy / medium / hard.
- `slug`: 소문자·하이픈.

### info.yml

```yaml
id: 13
title: etcd 스냅샷 백업
difficulty: medium
cert: cka                 # cka | ckad | cks
domain: cluster           # cka: troubleshooting cluster networking workloads storage
                          # ckad: environment design deployment networking observability
points: 8                 # 모의고사 배점 (%)
tags: [etcd, backup]
disruptive: false         # 다른 문항 환경을 깨뜨리는가 (스케줄러 정지, kubelet 정지, DNS 오염 ...)
setup_order: 0            # q exam start 가 setup 을 실행하는 순서. disruptive 는 10 이상, 전역 영향은 20
node_access: true         # docker exec 로 노드 진입이 필요한가
```

### 스크립트 규약

```bash
#!/usr/bin/env bash
set -euo pipefail                                     # cleanup.sh 는 set -uo (실패 무시)
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0013                                           # STATE=/tmp/cncf-state/0013, OUT=/tmp/cncf-out
```

- `lib.sh` 제공: `$K`(kubectl --context), `$CP_NODE/$W1/$W2`, `node_exec`, `node_sh`, `jp`, `cjp`, `ns_ensure`, `ns_delete`, `wait_deploy`, `wait_ready_pod`, `client_ensure`/`client_exec`/`http_ok`/`http_blocked`, 채점 `q_start expect expect_eq expect_ne expect_contains expect_not_contains expect_ge info q_end report`.
- check.sh 끝은 반드시 `q_end; report`. `q_end` 가 `RESULT <id> <득점> <배점> PASS|FAIL` 을 출력하고 `q exam check` 가 이를 집계.
- 사용자 결과 파일은 `$OUT/<파일명>` (지문에 `/tmp/cncf-out/...` 로 명시). 파일명은 전역 유일하게.
- 노드 작업은 `node_exec "$W2" systemctl ...`. 지문에는 `docker exec -it cka-worker2 bash` 로 안내.
- 재생성 금지 문항은 setup 에서 uid 를 `$STATE/` 에 저장하고 check 에서 비교.
- 다른 문항이 만든 리소스에 의존하지 않는다. 기능 테스트용 클라이언트는 `client_ensure` + `client_exec`.

### 검증

```bash
./bin/q start 0013 && ./bin/q check 0013      # FAIL 이어야 함
# solution.md 대로 풀기
./bin/q check 0013                            # PASS 이어야 함
./bin/q reset 0013
bash scripts/lint-questions.sh
bash scripts/gen-readme.sh                    # README 헤더·루트 목록 갱신 후 함께 커밋
```

CI 는 lint + README 최신 여부 + 변경된 문항의 setup/check(FAIL)/cleanup 스모크를 kind 에서 돌린다.

### 좋은 문제

- 실제 시험 유형 1개를 겨냥. 지문은 시험처럼 건조하게: 이름·네임스페이스·경로·조건 명시.
- 함정 1개 이상 (예: toleration 만 있고 nodeSelector 없음, CM 키 이름 불일치).
- 채점은 상태 검증 + 가능하면 기능 테스트(curl/nslookup). 지문에 없는 걸 채점하지 않는다.
- solution.md 에 "왜 틀리기 쉬운가" 를 적는다.

## 모의고사 추가

`<cert>/exams/exam-NN.yml`:

```yaml
title: CKA Mock Exam 01
duration_minutes: 120
pass_percent: 66
questions:
  - 0001
  - 0002
```

배점 합이 100 이 되게 문항을 고른다. disruptive 문항은 같은 노드/컴포넌트를 두 번 깨지 않게 조합.

## 노트

`<cert>/notes/` 도메인당 1파일. 시험에 나오는 것만. 명령·YAML 은 복붙 가능한 형태로.
