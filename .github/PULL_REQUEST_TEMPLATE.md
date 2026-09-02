## 변경 유형

- [ ] 새 문제 (`<cert>/questions/NNNN-<difficulty>-<slug>/`)
- [ ] 기존 문제 수정 (지문 / setup / check / solution)
- [ ] 노트 / 공통 자료
- [ ] 도구 (`bin/q`, `scripts/`, `common/setup/`, CI)

## 새 문제 체크리스트 (해당 시)

- [ ] `info.yml` 의 `id` 가 폴더 번호와 같고 중복 없음
- [ ] `setup.sh` 멱등 (두 번 실행해도 오류 없음), 자기 리소스만 생성
- [ ] `check.sh` 는 setup 직후 **FAIL**, solution 적용 후 **PASS** 확인함
- [ ] `cleanup.sh` 실행 후 `kubectl get all -A` 에 잔여 리소스 없음
- [ ] 지문에 리소스 이름·네임스페이스·경로가 정확히 명시됨 (채점 기준과 일치)
- [ ] `scripts/lint-questions.sh` 통과, `scripts/gen-readme.sh` 실행함 (README.md + README.ko.md)
- [ ] 다른 문항 환경을 깨뜨리면 `disruptive: true`, `setup_order: 10+`

## 설명

<!-- 왜 이 문제가 필요한지, 실제 시험의 어떤 유형을 겨냥하는지 -->
