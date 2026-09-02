<!--info-header-start--><h1>CRD 조회와 Custom Resource 생성 <img src="https://img.shields.io/badge/-easy-7aad0c" alt="easy"/> <img src="https://img.shields.io/badge/-%23cluster-999" alt="#cluster"/> <img src="https://img.shields.io/badge/-%23crd-999" alt="#crd"/> <img src="https://img.shields.io/badge/-5pt-2b7bb9" alt="5pt"/></h1><p><a href="https://codespaces.new/ten1010-io/cncf-certification-challenges?quickstart=1" target="_blank"><img src="https://img.shields.io/badge/-Open%20in%20Codespaces-24292f?logo=github" alt="Open in Codespaces"/></a> <a href="https://github.com/ten1010-io/cncf-certification-challenges/issues/new?title=0022%20-%20CRD%20%EC%A1%B0%ED%9A%8C%EC%99%80%20Custom%20Resource%20%EC%83%9D%EC%84%B1&labels=answer%2Ccka%2C0022&template=answer.yml" target="_blank"><img src="https://img.shields.io/badge/-Share%20your%20Solution-teal" alt="Share your Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification-challenges/issues?q=label%3Aanswer+label%3A0022" target="_blank"><img src="https://img.shields.io/badge/-Check%20out%20Solutions-de5a77" alt="Check out Solutions"/></a></p><!--info-header-end-->

## 문제

1. 클러스터에 설치된 CRD 중 API group `stable.example.com` 에 속하는 CRD 의 **이름**을 `/tmp/cncf-out/crds.txt` 에 한 줄씩 저장한다.
2. 그 CRD 의 kind 로 네임스페이스 `default` 에 Custom Resource `blue-shirt` 를 생성한다. `spec.color: blue`, `spec.size: M`. 스키마는 `kubectl explain` 으로 확인한다.

## 실행

```bash
q start 22      # 환경 구성 + 지문 출력
q check         # 채점
```

로컬(Codespaces 아님)이면 `./bin/q`. 풀이는 `q solution`, 환경 초기화는 `q reset`.

<!--info-footer-start--><br><a href="../../../README.md"><img src="https://img.shields.io/badge/-Back-grey" alt="Back"/></a> <a href="./solution.md"><img src="https://img.shields.io/badge/-Solution%20(spoiler)-red" alt="Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification-challenges/edit/main/cka/questions/0022-easy-crd-custom-resource/README.md"><img src="https://img.shields.io/badge/-Edit-blue" alt="Edit"/></a><!--info-footer-end-->
