# Contributing

풀이 공유는 **Issue**, 문제·노트·도구 추가는 **PR**.

## 풀이 공유 (Issue)

문제 README 상단 **Share your Solution** 클릭 → 제목·라벨이 채워진 이슈 폼. 명령·YAML·`q check` 출력·소요 시간·함정을 적는다.
다른 사람 풀이는 **Check out Solutions** (`label:answer label:NNNN`).

## 문제 추가

두 가지 경로. 결과는 같다.

### A. 이슈 폼 (권장, 코드 몰라도 됨)

1. Issues → New issue → **새 문제 제안 (New Question)** 폼 작성. 스크립트 필드는 본문만(헤더는 자동으로 붙는다).
2. GitHub Actions 가 폼을 검증해 코멘트한다. 실패하면 오류 목록 + `invalid` 라벨 → 본문을 수정하면 다시 검증한다.
3. 메인테이너가 내용을 확인하고 로컬에서 `q issue take <이슈번호>` 를 실행한다. 다음 번호를 배정해 문제 폴더를 만들고 lint·README 생성까지 마친 뒤 브랜치를 push 하고 PR 을 연다.
4. PR 리뷰 후 머지 → 이슈 자동 종료(`Closes #N`) → README 목록 갱신.

### B. 직접 PR

아래 규약대로 폴더를 만들어 PR. CI 가 lint + kind 스모크를 돈다.

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

- `NNNN`: 다음 빈 번호 (`q list` 로 확인). 자격증 간 번호 공유 (전역 유일).
- README 의 `## 실행` 블록은 `q start <번호>` / `q check` 두 줄 + 로컬 안내 한 줄 (기존 문제 복사).
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
q start 13 && q check         # FAIL 이어야 함
# solution.md 대로 풀기
q check                       # PASS 이어야 함
q reset
bash scripts/lint-questions.sh
bash scripts/gen-readme.sh    # 문제 README 헤더 + README.md/README.ko.md 갱신. 함께 커밋
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

## 메인테이너: 이슈를 문제로 반영하기

`gh` CLI 로 로그인되어 있어야 한다 (`brew install gh && gh auth login`).

```bash
q issue list            # 검토 대기 중인 제안 목록
q issue take 12         # 이슈 12 → 문제 폴더 생성 → 브랜치 → 커밋 → push → PR
q issue take 12 --no-pr # push/PR 없이 로컬 브랜치까지만 (검토용)
```

`q issue take` 가 하는 일:

1. `gh` 로 이슈 본문을 받아 폼을 검증한다.
2. `origin/main` 에서 `question/issue-<N>` 브랜치를 만든다.
3. 다음 빈 번호를 배정해 문제 폴더 6개 파일을 생성한다.
4. `lint-questions.sh` 와 `gen-readme.sh` 를 돌린다.
5. `Closes #N` 커밋 → push → PR 생성 → 이슈에 PR 링크 코멘트.
6. 원래 브랜치로 돌아온다.

머지 전에 실제로 풀어보려면 브랜치로 이동해 `q start <번호>` → `q check` 로 확인한다. 커밋되지 않은 변경이 있으면 명령이 중단되므로 작업 트리를 먼저 정리한다.

### 왜 봇이 PR 을 만들지 않나

조직 설정에서 *Allow GitHub Actions to create and approve pull requests* 가 꺼져 있으면 Actions 는 PR 을 만들 수 없다. 조직 관리자가 아니면 켤 수 없으므로, 검증만 Actions 가 하고 생성·PR 은 메인테이너 로컬에서 처리한다.

조직 설정을 켤 수 있거나 저장소 시크릿을 추가할 수 있다면 완전 자동화도 가능하다. `QUESTION_BOT_TOKEN` 시크릿에 fine-grained PAT(이 저장소 대상, Contents·Pull requests·Issues write)을 넣으면 PAT 이 사용자 자격으로 동작하므로 Actions 제한을 우회한다. 그 경우 워크플로우에 PR 생성 단계를 되살리면 된다.
