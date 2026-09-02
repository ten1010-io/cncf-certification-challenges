<!--info-header-start--><h1>Ingress 경로 라우팅 <img src="https://img.shields.io/badge/-easy-7aad0c" alt="easy"/> <img src="https://img.shields.io/badge/-%23networking-999" alt="#networking"/> <img src="https://img.shields.io/badge/-%23ingress-999" alt="#ingress"/> <img src="https://img.shields.io/badge/-5pt-2b7bb9" alt="5pt"/></h1><p><a href="https://codespaces.new/ten1010-io/cncf-certification?quickstart=1" target="_blank"><img src="https://img.shields.io/badge/-Open%20in%20Codespaces-24292f?logo=github" alt="Open in Codespaces"/></a> <a href="https://github.com/ten1010-io/cncf-certification/issues/new?title=0011%20-%20Ingress%20%EA%B2%BD%EB%A1%9C%20%EB%9D%BC%EC%9A%B0%ED%8C%85&labels=answer%2Ccka%2C0011&template=answer.yml" target="_blank"><img src="https://img.shields.io/badge/-Share%20your%20Solution-teal" alt="Share your Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification/issues?q=label%3Aanswer+label%3A0011" target="_blank"><img src="https://img.shields.io/badge/-Check%20out%20Solutions-de5a77" alt="Check out Solutions"/></a></p><!--info-header-end-->

## 문제

네임스페이스 `shop` 에 Service `shop-web`(80) 과 `shop-api`(80) 가 있다. Ingress `shop-ingress` 를 생성한다.

- ingressClassName `nginx`
- host `shop.local`
- 경로 `/api` (pathType `Prefix`) → `shop-api:80`
- 경로 `/` (pathType `Prefix`) → `shop-web:80`

## 실행

```bash
q start 11      # 환경 구성 + 지문 출력
q check         # 채점
```

로컬(Codespaces 아님)이면 `./bin/q`. 풀이는 `q solution`, 환경 초기화는 `q reset`.

<!--info-footer-start--><br><a href="../../../README.md"><img src="https://img.shields.io/badge/-Back-grey" alt="Back"/></a> <a href="./solution.md"><img src="https://img.shields.io/badge/-Solution%20(spoiler)-red" alt="Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification/edit/main/cka/questions/0011-easy-ingress-shop/README.md"><img src="https://img.shields.io/badge/-Edit-blue" alt="Edit"/></a><!--info-footer-end-->
