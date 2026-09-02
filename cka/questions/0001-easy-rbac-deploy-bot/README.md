<!--info-header-start--><h1>RBAC ServiceAccount 권한 부여 <img src="https://img.shields.io/badge/-easy-7aad0c" alt="easy"/> <img src="https://img.shields.io/badge/-%23cluster-999" alt="#cluster"/> <img src="https://img.shields.io/badge/-%23rbac-999" alt="#rbac"/> <img src="https://img.shields.io/badge/-%23serviceaccount-999" alt="#serviceaccount"/> <img src="https://img.shields.io/badge/-4pt-2b7bb9" alt="4pt"/></h1><p><a href="https://codespaces.new/ten1010-io/cncf-certification-challenges?quickstart=1" target="_blank"><img src="https://img.shields.io/badge/-Open%20in%20Codespaces-24292f?logo=github" alt="Open in Codespaces"/></a> <a href="https://github.com/ten1010-io/cncf-certification-challenges/issues/new?title=0001%20-%20RBAC%20ServiceAccount%20%EA%B6%8C%ED%95%9C%20%EB%B6%80%EC%97%AC&labels=answer%2Ccka%2C0001&template=answer.yml" target="_blank"><img src="https://img.shields.io/badge/-Share%20your%20Solution-teal" alt="Share your Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification-challenges/issues?q=label%3Aanswer+label%3A0001" target="_blank"><img src="https://img.shields.io/badge/-Check%20out%20Solutions-de5a77" alt="Check out Solutions"/></a></p><!--info-header-end-->

## 문제

네임스페이스 `ci` 에 다음을 생성한다.

- ServiceAccount `deploy-bot`
- Role `deploy-manager`: `deployments` 리소스에 `get, list, create, update, delete`, `pods` 리소스에 `get, list` 권한
- RoleBinding `deploy-bot-rb`: 위 Role 을 `deploy-bot` 에 바인딩

`deploy-bot` 은 `ci` 네임스페이스 밖에서는 아무 권한이 없어야 한다.

## 실행

```bash
q start 1      # 환경 구성 + 지문 출력
q check         # 채점
```

로컬(Codespaces 아님)이면 `./bin/q`. 풀이는 `q solution`, 환경 초기화는 `q reset`.

<!--info-footer-start--><br><a href="../../../README.md"><img src="https://img.shields.io/badge/-Back-grey" alt="Back"/></a> <a href="./solution.md"><img src="https://img.shields.io/badge/-Solution%20(spoiler)-red" alt="Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification-challenges/edit/main/cka/questions/0001-easy-rbac-deploy-bot/README.md"><img src="https://img.shields.io/badge/-Edit-blue" alt="Edit"/></a><!--info-footer-end-->
