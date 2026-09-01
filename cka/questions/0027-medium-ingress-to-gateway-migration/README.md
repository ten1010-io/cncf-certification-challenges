<!--info-header-start--><h1>Ingress → Gateway API 마이그레이션 <img src="https://img.shields.io/badge/-medium-d9901a" alt="medium"/> <img src="https://img.shields.io/badge/-%23networking-999" alt="#networking"/> <img src="https://img.shields.io/badge/-%23ingress-999" alt="#ingress"/> <img src="https://img.shields.io/badge/-%23gateway-api-999" alt="#gateway-api"/> <img src="https://img.shields.io/badge/-%23httproute-999" alt="#httproute"/> <img src="https://img.shields.io/badge/-7pt-2b7bb9" alt="7pt"/></h1><p><a href="https://codespaces.new/ten1010-io/cncf-certification?quickstart=1" target="_blank"><img src="https://img.shields.io/badge/-Open%20in%20Codespaces-24292f?logo=github" alt="Open in Codespaces"/></a> <a href="https://github.com/ten1010-io/cncf-certification/issues/new?title=0027%20-%20Ingress%20%E2%86%92%20Gateway%20API%20%EB%A7%88%EC%9D%B4%EA%B7%B8%EB%A0%88%EC%9D%B4%EC%85%98&labels=answer%2Ccka%2C0027&template=answer.yml" target="_blank"><img src="https://img.shields.io/badge/-Share%20your%20Solution-teal" alt="Share your Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification/issues?q=label%3Aanswer+label%3A0027" target="_blank"><img src="https://img.shields.io/badge/-Check%20out%20Solutions-de5a77" alt="Check out Solutions"/></a></p><!--info-header-end-->

## 문제

네임스페이스 `web` 에 Ingress `legacy` 가 있다 (host `app.local`, `/` → `app-svc:80`, `/v2` → `app-v2-svc:80`).

동일한 라우팅을 Gateway API 로 옮긴다.

- Gateway `web-gw`: gatewayClassName `nginx`, listener 이름 `http`, 프로토콜 HTTP, 포트 80
- HTTPRoute `app-route`: parentRef `web-gw`, hostname `app.local`, 경로 규칙은 Ingress 와 동일 (`PathPrefix`)
- 마이그레이션 후 Ingress `legacy` 를 삭제한다.

## 실행

```bash
./bin/q start 0027
./bin/q check 0027
```

<!--info-footer-start--><br><a href="../../../README.md"><img src="https://img.shields.io/badge/-Back-grey" alt="Back"/></a> <a href="./solution.md"><img src="https://img.shields.io/badge/-Solution%20(spoiler)-red" alt="Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification/edit/main/cka/questions/0027-medium-ingress-to-gateway-migration/README.md"><img src="https://img.shields.io/badge/-Edit-blue" alt="Edit"/></a><!--info-footer-end-->
