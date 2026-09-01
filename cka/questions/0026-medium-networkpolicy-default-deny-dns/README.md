<!--info-header-start--><h1>NetworkPolicy default-deny + DNS 허용 <img src="https://img.shields.io/badge/-medium-d9901a" alt="medium"/> <img src="https://img.shields.io/badge/-%23networking-999" alt="#networking"/> <img src="https://img.shields.io/badge/-%23networkpolicy-999" alt="#networkpolicy"/> <img src="https://img.shields.io/badge/-%23dns-999" alt="#dns"/> <img src="https://img.shields.io/badge/-7pt-2b7bb9" alt="7pt"/></h1><p><a href="https://codespaces.new/ten1010-io/cncf-certification?quickstart=1" target="_blank"><img src="https://img.shields.io/badge/-Open%20in%20Codespaces-24292f?logo=github" alt="Open in Codespaces"/></a> <a href="https://github.com/ten1010-io/cncf-certification/issues/new?title=0026%20-%20NetworkPolicy%20default-deny%20%2B%20DNS%20%ED%97%88%EC%9A%A9&labels=answer%2Ccka%2C0026&template=answer.yml" target="_blank"><img src="https://img.shields.io/badge/-Share%20your%20Solution-teal" alt="Share your Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification/issues?q=label%3Aanswer+label%3A0026" target="_blank"><img src="https://img.shields.io/badge/-Check%20out%20Solutions-de5a77" alt="Check out Solutions"/></a></p><!--info-header-end-->

## 문제

네임스페이스 `secure` 에 두 NetworkPolicy 를 생성한다.

- `default-deny`: 네임스페이스의 모든 Pod 에 대해 ingress, egress 를 전부 차단
- `allow-dns`: 모든 Pod 의 egress 중 **DNS(UDP/TCP 53)** 만 어떤 목적지로든 허용

결과: `secure/worker` Pod 에서 `nslookup kubernetes.default` 는 성공하고, 다른 네임스페이스(`public`) 의 Pod 로의 HTTP 접근은 실패해야 한다.

## 실행

```bash
./bin/q start 0026
./bin/q check 0026
```

<!--info-footer-start--><br><a href="../../../README.md"><img src="https://img.shields.io/badge/-Back-grey" alt="Back"/></a> <a href="./solution.md"><img src="https://img.shields.io/badge/-Solution%20(spoiler)-red" alt="Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification/edit/main/cka/questions/0026-medium-networkpolicy-default-deny-dns/README.md"><img src="https://img.shields.io/badge/-Edit-blue" alt="Edit"/></a><!--info-footer-end-->
