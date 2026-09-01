<!--info-header-start--><h1>Pending Pod 해결 (리소스 요구 + nodeSelector) <img src="https://img.shields.io/badge/-medium-d9901a" alt="medium"/> <img src="https://img.shields.io/badge/-%23troubleshooting-999" alt="#troubleshooting"/> <img src="https://img.shields.io/badge/-%23scheduling-999" alt="#scheduling"/> <img src="https://img.shields.io/badge/-%23resources-999" alt="#resources"/> <img src="https://img.shields.io/badge/-%23nodeselector-999" alt="#nodeselector"/> <img src="https://img.shields.io/badge/-6pt-2b7bb9" alt="6pt"/></h1><p><a href="https://codespaces.new/ten1010-io/cncf-certification?quickstart=1" target="_blank"><img src="https://img.shields.io/badge/-Open%20in%20Codespaces-24292f?logo=github" alt="Open in Codespaces"/></a> <a href="https://github.com/ten1010-io/cncf-certification/issues/new?title=0024%20-%20Pending%20Pod%20%ED%95%B4%EA%B2%B0%20%28%EB%A6%AC%EC%86%8C%EC%8A%A4%20%EC%9A%94%EA%B5%AC%20%2B%20nodeSelector%29&labels=answer%2Ccka%2C0024&template=answer.yml" target="_blank"><img src="https://img.shields.io/badge/-Share%20your%20Solution-teal" alt="Share your Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification/issues?q=label%3Aanswer+label%3A0024" target="_blank"><img src="https://img.shields.io/badge/-Check%20out%20Solutions-de5a77" alt="Check out Solutions"/></a></p><!--info-header-end-->

## 문제

네임스페이스 `heavy` 의 Deployment `heavy` 가 스케줄되지 않는다.

- 리소스 요구를 `memory 128Mi`, `cpu 100m` 으로 조정한다 (limits 도 동일하게).
- 이 워크로드는 SSD 노드(`disktype=ssd`)에서만 실행되어야 한다. `cka-worker` 가 SSD 노드다. Deployment 의 nodeSelector 는 유지하고 노드 쪽을 맞춘다.

Pod 1개가 `cka-worker` 에서 `Running` 이어야 한다.

## 실행

```bash
./bin/q start 0024
./bin/q check 0024
```

<!--info-footer-start--><br><a href="../../../README.md"><img src="https://img.shields.io/badge/-Back-grey" alt="Back"/></a> <a href="./solution.md"><img src="https://img.shields.io/badge/-Solution%20(spoiler)-red" alt="Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification/edit/main/cka/questions/0024-medium-pending-pod-resources-nodeselector/README.md"><img src="https://img.shields.io/badge/-Edit-blue" alt="Edit"/></a><!--info-footer-end-->
