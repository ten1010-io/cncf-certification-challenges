<!--info-header-start--><h1>Secret 환경변수·볼륨 주입 <img src="https://img.shields.io/badge/-easy-7aad0c" alt="easy"/> <img src="https://img.shields.io/badge/-%23workloads-999" alt="#workloads"/> <img src="https://img.shields.io/badge/-%23secret-999" alt="#secret"/> <img src="https://img.shields.io/badge/-%23env-999" alt="#env"/> <img src="https://img.shields.io/badge/-%23volume-999" alt="#volume"/> <img src="https://img.shields.io/badge/-5pt-2b7bb9" alt="5pt"/></h1><p><a href="https://codespaces.new/ten1010-io/cncf-certification-challenges?quickstart=1" target="_blank"><img src="https://img.shields.io/badge/-Open%20in%20Codespaces-24292f?logo=github" alt="Open in Codespaces"/></a> <a href="https://github.com/ten1010-io/cncf-certification-challenges/issues/new?title=0028%20-%20Secret%20%ED%99%98%EA%B2%BD%EB%B3%80%EC%88%98%C2%B7%EB%B3%BC%EB%A5%A8%20%EC%A3%BC%EC%9E%85&labels=answer%2Ccka%2C0028&template=answer.yml" target="_blank"><img src="https://img.shields.io/badge/-Share%20your%20Solution-teal" alt="Share your Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification-challenges/issues?q=label%3Aanswer+label%3A0028" target="_blank"><img src="https://img.shields.io/badge/-Check%20out%20Solutions-de5a77" alt="Check out Solutions"/></a></p><!--info-header-end-->

## 문제

네임스페이스 `secure-app` 에 다음을 생성한다.

- Secret `db-creds`: `username=admin`, `password=s3cr3t`
- Pod `secure-app`: 이미지 `busybox:1.36`, 명령 `sleep 3600`
  - 환경변수 `DB_USER` ← Secret 의 `username` 키
  - Secret 전체를 `/etc/creds` 에 **읽기 전용**으로 마운트

## 실행

```bash
q start 28      # 환경 구성 + 지문 출력
q check         # 채점
```

로컬(Codespaces 아님)이면 `./bin/q`. 풀이는 `q solution`, 환경 초기화는 `q reset`.

<!--info-footer-start--><br><a href="../../../README.md"><img src="https://img.shields.io/badge/-Back-grey" alt="Back"/></a> <a href="./solution.md"><img src="https://img.shields.io/badge/-Solution%20(spoiler)-red" alt="Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification-challenges/edit/main/cka/questions/0028-easy-secret-env-volume/README.md"><img src="https://img.shields.io/badge/-Edit-blue" alt="Edit"/></a><!--info-footer-end-->
