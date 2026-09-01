<!-- 이 파일은 scripts/gen-readme.sh 가 생성한다. 직접 수정하지 말고 scripts/templates/ 와 각 문제의 info.yml 을 수정. -->
<h1 align="center">CNCF Certification Challenges</h1>

<p align="center">
CKA · CKAD · CKS 실습형 문제 은행. 브라우저(Codespaces) 안 실제 Kubernetes 클러스터에서 풀고, 자동 채점하고, Issue 로 풀이를 공유한다.<br>
<sub>Hands-on Kubernetes certification challenges with auto-grading. Structure inspired by <a href="https://github.com/type-challenges/type-challenges">type-challenges</a>.</sub>
</p>

<p align="center">
<a href="https://codespaces.new/{{REPO}}?quickstart=1"><img src="https://img.shields.io/badge/-Open%20in%20Codespaces-24292f?logo=github&style=for-the-badge" alt="Open in Codespaces"/></a>
<a href="https://github.com/{{REPO}}/issues?q=label%3Aanswer"><img src="https://img.shields.io/badge/-Solutions-de5a77?style=for-the-badge" alt="Solutions"/></a>
<a href="./CONTRIBUTING.md"><img src="https://img.shields.io/badge/-Add%20a%20Question-teal?style=for-the-badge" alt="Contribute"/></a>
</p>

## 사용법

```bash
# 1. 클러스터 (Codespaces 또는 로컬 Docker). 한 번만.
./bin/q cluster up

# 2. 문제 하나 풀기
./bin/q list cka                 # 목록 (--domain troubleshooting --difficulty hard 필터)
./bin/q start 0013               # 환경 구성 → cka/questions/0013-*/README.md 읽고 풀기
./bin/q check 0013               # 채점
./bin/q solution 0013            # 풀이 (스포일러)

# 3. 모의고사 (2시간, 17문항)
./bin/q exam start exam-01       # 문제지: /tmp/cncf-out/cka-exam-01-questions.md
./bin/q exam check exam-01       # 합산 채점, 합격 판정
```

풀고 나서 각 문제의 **Share your Solution** 버튼 → Issue 에 명령·YAML·`q check` 출력 붙이기. 다른 사람 풀이는 **Check out Solutions**.

난이도: <img src="https://img.shields.io/badge/-easy-7aad0c"/> <img src="https://img.shields.io/badge/-medium-d9901a"/> <img src="https://img.shields.io/badge/-hard-de3d37"/>

