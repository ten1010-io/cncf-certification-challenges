<!-- 이 파일은 scripts/gen-readme.sh 가 생성한다. 직접 수정하지 말고 scripts/templates/ 와 각 문제의 info.yml 을 수정. -->
<h1 align="center">CNCF Certification Challenges</h1>

<p align="center">
CKA · CKAD · CKS 실습형 문제 은행. 브라우저(Codespaces) 안 실제 Kubernetes 클러스터에서 풀고, 자동 채점하고, Issue 로 풀이를 공유한다.<br>
<sub>Hands-on Kubernetes certification challenges with auto-grading. Structure inspired by <a href="https://github.com/type-challenges/type-challenges">type-challenges</a>.</sub>
</p>

<p align="center">
<a href="https://codespaces.new/{{REPO}}?quickstart=1"><img src="https://img.shields.io/badge/-Open%20in%20Codespaces-24292f?logo=github&style=for-the-badge" alt="Open in Codespaces"/></a>
<a href="https://github.com/{{REPO}}/issues?q=label%3Aanswer"><img src="https://img.shields.io/badge/-Solutions-de5a77?style=for-the-badge" alt="Solutions"/></a>
<a href="https://github.com/{{REPO}}/issues/new?template=new-question.yml"><img src="https://img.shields.io/badge/-Add%20a%20Question-teal?style=for-the-badge" alt="Add a Question"/></a>
</p>

## 사용법

Codespaces 는 열리면 클러스터를 백그라운드로 자동 생성한다(첫 3~5분). 터미널에서:

```bash
q start 13          # 환경 구성 + 지문 출력. 이제 kubectl 로 풀기
q check             # 채점 (마지막 start 한 문제)
q solution          # 풀이 (스포일러)
q list cka          # 목록 (--domain troubleshooting --difficulty hard 필터)

q exam start exam-01   # 모의고사 17문항 2시간. 문제지 /tmp/cncf-out/cka-exam-01-questions.md
q exam check exam-01   # 합산 채점, 합격 판정
```

로컬(Docker + kind + kubectl)에서는 `./bin/q cluster up` 먼저.

풀고 나서 각 문제의 **Share your Solution** 버튼 → Issue 에 명령·YAML·`q check` 출력 붙이기. 다른 사람 풀이는 **Check out Solutions**.
새 문제는 **Add a Question** 이슈 폼 → 봇이 PR 생성 → 메인테이너 `approved` 라벨 → 자동 머지.

난이도: <img src="https://img.shields.io/badge/-easy-7aad0c"/> <img src="https://img.shields.io/badge/-medium-d9901a"/> <img src="https://img.shields.io/badge/-hard-de3d37"/>

