<!--info-header-start--><h1>롤링 업데이트와 롤백 <img src="https://img.shields.io/badge/-easy-7aad0c" alt="easy"/> <img src="https://img.shields.io/badge/-%23workloads-999" alt="#workloads"/> <img src="https://img.shields.io/badge/-%23deployment-999" alt="#deployment"/> <img src="https://img.shields.io/badge/-%23rollout-999" alt="#rollout"/> <img src="https://img.shields.io/badge/-5pt-2b7bb9" alt="5pt"/></h1><p><a href="https://codespaces.new/ten1010-io/cncf-certification?quickstart=1" target="_blank"><img src="https://img.shields.io/badge/-Open%20in%20Codespaces-24292f?logo=github" alt="Open in Codespaces"/></a> <a href="https://github.com/ten1010-io/cncf-certification/issues/new?title=0004%20-%20%EB%A1%A4%EB%A7%81%20%EC%97%85%EB%8D%B0%EC%9D%B4%ED%8A%B8%EC%99%80%20%EB%A1%A4%EB%B0%B1&labels=answer%2Ccka%2C0004&template=answer.yml" target="_blank"><img src="https://img.shields.io/badge/-Share%20your%20Solution-teal" alt="Share your Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification/issues?q=label%3Aanswer+label%3A0004" target="_blank"><img src="https://img.shields.io/badge/-Check%20out%20Solutions-de5a77" alt="Check out Solutions"/></a></p><!--info-header-end-->

## 문제

네임스페이스 `api` 의 Deployment `api`(현재 이미지 `nginx:1.24`, replicas 2) 를 다룬다.

1. 이미지를 `nginx:1.25` 로 업데이트하고 롤아웃이 완료될 때까지 기다린다.
2. 새 버전에 문제가 발견되었다고 가정하고 **직전 버전으로 롤백**한다.

최종 상태:

- 이미지 `nginx:1.24`, 2개 replica Ready
- 롤아웃 히스토리에 업데이트와 롤백 기록이 남아 있어야 한다.
- Deployment 를 삭제하고 재생성하지 말 것.

## 실행

```bash
q start 4      # 환경 구성 + 지문 출력
q check         # 채점
```

로컬(Codespaces 아님)이면 `./bin/q`. 풀이는 `q solution`, 환경 초기화는 `q reset`.

<!--info-footer-start--><br><a href="../../../README.md"><img src="https://img.shields.io/badge/-Back-grey" alt="Back"/></a> <a href="./solution.md"><img src="https://img.shields.io/badge/-Solution%20(spoiler)-red" alt="Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification/edit/main/cka/questions/0004-easy-rollout-rollback/README.md"><img src="https://img.shields.io/badge/-Edit-blue" alt="Edit"/></a><!--info-footer-end-->
