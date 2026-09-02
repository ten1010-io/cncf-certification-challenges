<!--info-header-start--><h1>Helm 설치와 업그레이드 <img src="https://img.shields.io/badge/-medium-d9901a" alt="medium"/> <img src="https://img.shields.io/badge/-%23cluster-999" alt="#cluster"/> <img src="https://img.shields.io/badge/-%23helm-999" alt="#helm"/> <img src="https://img.shields.io/badge/-6pt-2b7bb9" alt="6pt"/></h1><p><a href="https://codespaces.new/ten1010-io/cncf-certification-challenges?quickstart=1" target="_blank"><img src="https://img.shields.io/badge/-Open%20in%20Codespaces-24292f?logo=github" alt="Open in Codespaces"/></a> <a href="https://github.com/ten1010-io/cncf-certification-challenges/issues/new?title=0020%20-%20Helm%20%EC%84%A4%EC%B9%98%EC%99%80%20%EC%97%85%EA%B7%B8%EB%A0%88%EC%9D%B4%EB%93%9C&labels=answer%2Ccka%2C0020&template=answer.yml" target="_blank"><img src="https://img.shields.io/badge/-Share%20your%20Solution-teal" alt="Share your Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification-challenges/issues?q=label%3Aanswer+label%3A0020" target="_blank"><img src="https://img.shields.io/badge/-Check%20out%20Solutions-de5a77" alt="Check out Solutions"/></a></p><!--info-header-end-->

## 문제

로컬 경로 `/tmp/cncf-out/charts/` 에 패키징된 차트 `webapp-0.1.0.tgz`, `webapp-0.2.0.tgz` 가 있다.

1. 네임스페이스 `helm-shop`(없으면 생성)에 릴리스 `shop-web` 으로 `webapp` **0.1.0** 을 설치한다. 값 `replicaCount=2`.
2. 설치 확인 후 릴리스를 **0.2.0** 으로 업그레이드한다. `replicaCount=2` 는 유지한다.
3. `helm history shop-web -n helm-shop` 결과를 `/tmp/cncf-out/helm-history.txt` 에 저장한다.

## 실행

```bash
q start 20      # 환경 구성 + 지문 출력
q check         # 채점
```

로컬(Codespaces 아님)이면 `./bin/q`. 풀이는 `q solution`, 환경 초기화는 `q reset`.

<!--info-footer-start--><br><a href="../../../README.md"><img src="https://img.shields.io/badge/-Back-grey" alt="Back"/></a> <a href="./solution.md"><img src="https://img.shields.io/badge/-Solution%20(spoiler)-red" alt="Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification-challenges/edit/main/cka/questions/0020-medium-helm-install-upgrade/README.md"><img src="https://img.shields.io/badge/-Edit-blue" alt="Edit"/></a><!--info-footer-end-->
