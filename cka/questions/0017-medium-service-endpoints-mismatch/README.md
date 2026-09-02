<!--info-header-start--><h1>Service 연결 불가 (selector, targetPort 불일치) <img src="https://img.shields.io/badge/-medium-d9901a" alt="medium"/> <img src="https://img.shields.io/badge/-%23troubleshooting-999" alt="#troubleshooting"/> <img src="https://img.shields.io/badge/-%23service-999" alt="#service"/> <img src="https://img.shields.io/badge/-%23endpoints-999" alt="#endpoints"/> <img src="https://img.shields.io/badge/-%23selector-999" alt="#selector"/> <img src="https://img.shields.io/badge/-7pt-2b7bb9" alt="7pt"/></h1><p><a href="https://codespaces.new/ten1010-io/cncf-certification-challenges?quickstart=1" target="_blank"><img src="https://img.shields.io/badge/-Open%20in%20Codespaces-24292f?logo=github" alt="Open in Codespaces"/></a> <a href="https://github.com/ten1010-io/cncf-certification-challenges/issues/new?title=0017%20-%20Service%20%EC%97%B0%EA%B2%B0%20%EB%B6%88%EA%B0%80%20%28selector%2C%20targetPort%20%EB%B6%88%EC%9D%BC%EC%B9%98%29&labels=answer%2Ccka%2C0017&template=answer.yml" target="_blank"><img src="https://img.shields.io/badge/-Share%20your%20Solution-teal" alt="Share your Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification-challenges/issues?q=label%3Aanswer+label%3A0017" target="_blank"><img src="https://img.shields.io/badge/-Check%20out%20Solutions-de5a77" alt="Check out Solutions"/></a></p><!--info-header-end-->

## 문제

네임스페이스 `checkout` 의 Service `checkout-svc` 로 접속이 되지 않는다. Deployment `checkout` 은 정상이다.

Service 를 수정해 `checkout-svc:80` 으로 Deployment 의 Pod 에 접근되게 한다. Deployment 는 수정·삭제하지 말 것.

## 실행

```bash
q start 17      # 환경 구성 + 지문 출력
q check         # 채점
```

로컬(Codespaces 아님)이면 `./bin/q`. 풀이는 `q solution`, 환경 초기화는 `q reset`.

<!--info-footer-start--><br><a href="../../../README.md"><img src="https://img.shields.io/badge/-Back-grey" alt="Back"/></a> <a href="./solution.md"><img src="https://img.shields.io/badge/-Solution%20(spoiler)-red" alt="Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification-challenges/edit/main/cka/questions/0017-medium-service-endpoints-mismatch/README.md"><img src="https://img.shields.io/badge/-Edit-blue" alt="Edit"/></a><!--info-footer-end-->
