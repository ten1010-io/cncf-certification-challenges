<!--info-header-start--><h1>Kustomize overlay 작성과 적용 <img src="https://img.shields.io/badge/-medium-d9901a" alt="medium"/> <img src="https://img.shields.io/badge/-%23cluster-999" alt="#cluster"/> <img src="https://img.shields.io/badge/-%23kustomize-999" alt="#kustomize"/> <img src="https://img.shields.io/badge/-5pt-2b7bb9" alt="5pt"/></h1><p><a href="https://codespaces.new/ten1010-io/cncf-certification?quickstart=1" target="_blank"><img src="https://img.shields.io/badge/-Open%20in%20Codespaces-24292f?logo=github" alt="Open in Codespaces"/></a> <a href="https://github.com/ten1010-io/cncf-certification/issues/new?title=0021%20-%20Kustomize%20overlay%20%EC%9E%91%EC%84%B1%EA%B3%BC%20%EC%A0%81%EC%9A%A9&labels=answer%2Ccka%2C0021&template=answer.yml" target="_blank"><img src="https://img.shields.io/badge/-Share%20your%20Solution-teal" alt="Share your Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification/issues?q=label%3Aanswer+label%3A0021" target="_blank"><img src="https://img.shields.io/badge/-Check%20out%20Solutions-de5a77" alt="Check out Solutions"/></a></p><!--info-header-end-->

## 문제

`/tmp/cncf-out/kustomize/base/` 에 Deployment `web` 과 Service `web` 의 base 가 있다.
`/tmp/cncf-out/kustomize/overlays/prod/` 에 overlay 를 작성하고 적용한다.

- namespace `kprod` (없으면 생성)
- namePrefix `prod-`
- Deployment replicas 3
- 이미지 `nginx` 의 태그를 `1.25` 로 변경

적용 결과: `kprod` 네임스페이스에 Deployment `prod-web`(replicas 3, `nginx:1.25`) 과 Service `prod-web`.

## 실행

```bash
q start 21      # 환경 구성 + 지문 출력
q check         # 채점
```

로컬(Codespaces 아님)이면 `./bin/q`. 풀이는 `q solution`, 환경 초기화는 `q reset`.

<!--info-footer-start--><br><a href="../../../README.md"><img src="https://img.shields.io/badge/-Back-grey" alt="Back"/></a> <a href="./solution.md"><img src="https://img.shields.io/badge/-Solution%20(spoiler)-red" alt="Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification/edit/main/cka/questions/0021-medium-kustomize-overlay/README.md"><img src="https://img.shields.io/badge/-Edit-blue" alt="Edit"/></a><!--info-footer-end-->
