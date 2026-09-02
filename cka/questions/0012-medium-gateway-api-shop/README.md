<!--info-header-start--><h1>Gateway API — Gateway + HTTPRoute <img src="https://img.shields.io/badge/-medium-d9901a" alt="medium"/> <img src="https://img.shields.io/badge/-%23networking-999" alt="#networking"/> <img src="https://img.shields.io/badge/-%23gateway-api-999" alt="#gateway-api"/> <img src="https://img.shields.io/badge/-%23httproute-999" alt="#httproute"/> <img src="https://img.shields.io/badge/-5pt-2b7bb9" alt="5pt"/></h1><p><a href="https://codespaces.new/ten1010-io/cncf-certification?quickstart=1" target="_blank"><img src="https://img.shields.io/badge/-Open%20in%20Codespaces-24292f?logo=github" alt="Open in Codespaces"/></a> <a href="https://github.com/ten1010-io/cncf-certification/issues/new?title=0012%20-%20Gateway%20API%20%E2%80%94%20Gateway%20%2B%20HTTPRoute&labels=answer%2Ccka%2C0012&template=answer.yml" target="_blank"><img src="https://img.shields.io/badge/-Share%20your%20Solution-teal" alt="Share your Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification/issues?q=label%3Aanswer+label%3A0012" target="_blank"><img src="https://img.shields.io/badge/-Check%20out%20Solutions-de5a77" alt="Check out Solutions"/></a></p><!--info-header-end-->

## 문제

네임스페이스 `shop-gw` 에 Service `shop-web`(80) 과 `shop-api`(80) 가 있다. Gateway API 리소스를 생성한다. (이 환경에는 Gateway 컨트롤러가 없어 실제 트래픽은 흐르지 않는다. 스펙만 채점한다.)

- Gateway `shop-gw`: gatewayClassName `nginx`, listener 이름 `http`, protocol `HTTP`, port 80
- HTTPRoute `shop-route`: parentRef `shop-gw`, hostname `shop.local`
  - `PathPrefix /api` → backend `shop-api` port 80
  - `PathPrefix /` → backend `shop-web` port 80

## 실행

```bash
q start 12      # 환경 구성 + 지문 출력
q check         # 채점
```

로컬(Codespaces 아님)이면 `./bin/q`. 풀이는 `q solution`, 환경 초기화는 `q reset`.

<!--info-footer-start--><br><a href="../../../README.md"><img src="https://img.shields.io/badge/-Back-grey" alt="Back"/></a> <a href="./solution.md"><img src="https://img.shields.io/badge/-Solution%20(spoiler)-red" alt="Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification/edit/main/cka/questions/0012-medium-gateway-api-shop/README.md"><img src="https://img.shields.io/badge/-Edit-blue" alt="Edit"/></a><!--info-footer-end-->
