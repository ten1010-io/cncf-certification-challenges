<!--info-header-start--><h1>고장난 Deployment 수정 <img src="https://img.shields.io/badge/-medium-d9901a" alt="medium"/> <img src="https://img.shields.io/badge/-%23troubleshooting-999" alt="#troubleshooting"/> <img src="https://img.shields.io/badge/-%23deployment-999" alt="#deployment"/> <img src="https://img.shields.io/badge/-%23imagepullbackoff-999" alt="#imagepullbackoff"/> <img src="https://img.shields.io/badge/-%23configmap-999" alt="#configmap"/> <img src="https://img.shields.io/badge/-8pt-2b7bb9" alt="8pt"/></h1><p><a href="https://codespaces.new/ten1010-io/cncf-certification-challenges?quickstart=1" target="_blank"><img src="https://img.shields.io/badge/-Open%20in%20Codespaces-24292f?logo=github" alt="Open in Codespaces"/></a> <a href="https://github.com/ten1010-io/cncf-certification-challenges/issues/new?title=0003%20-%20%EA%B3%A0%EC%9E%A5%EB%82%9C%20Deployment%20%EC%88%98%EC%A0%95&labels=answer%2Ccka%2C0003&template=answer.yml" target="_blank"><img src="https://img.shields.io/badge/-Share%20your%20Solution-teal" alt="Share your Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification-challenges/issues?q=label%3Aanswer+label%3A0003" target="_blank"><img src="https://img.shields.io/badge/-Check%20out%20Solutions-de5a77" alt="Check out Solutions"/></a></p><!--info-header-end-->

## 문제

네임스페이스 `catalog` 의 Deployment `catalog` 의 Pod 가 정상 기동하지 않는다.

- 원인을 **모두** 찾아 수정하고 2개 replica 가 `Running/Ready` 가 되게 한다.
- 이미지는 `nginx:1.25` 여야 한다.
- Deployment 를 삭제하고 재생성하지 말 것.

## 실행

```bash
q start 3      # 환경 구성 + 지문 출력
q check         # 채점
```

로컬(Codespaces 아님)이면 `./bin/q`. 풀이는 `q solution`, 환경 초기화는 `q reset`.

<!--info-footer-start--><br><a href="../../../README.md"><img src="https://img.shields.io/badge/-Back-grey" alt="Back"/></a> <a href="./solution.md"><img src="https://img.shields.io/badge/-Solution%20(spoiler)-red" alt="Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification-challenges/edit/main/cka/questions/0003-medium-broken-deployment-catalog/README.md"><img src="https://img.shields.io/badge/-Edit-blue" alt="Edit"/></a><!--info-footer-end-->
