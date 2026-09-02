<!--info-header-start--><h1>노드 NotReady 복구 (kubelet kubeconfig 포트 오류) <img src="https://img.shields.io/badge/-hard-de3d37" alt="hard"/> <img src="https://img.shields.io/badge/-%23troubleshooting-999" alt="#troubleshooting"/> <img src="https://img.shields.io/badge/-%23node-999" alt="#node"/> <img src="https://img.shields.io/badge/-%23kubelet-999" alt="#kubelet"/> <img src="https://img.shields.io/badge/-%23kubeconfig-999" alt="#kubeconfig"/> <img src="https://img.shields.io/badge/-8pt-2b7bb9" alt="8pt"/></h1><p><a href="https://codespaces.new/ten1010-io/cncf-certification-challenges?quickstart=1" target="_blank"><img src="https://img.shields.io/badge/-Open%20in%20Codespaces-24292f?logo=github" alt="Open in Codespaces"/></a> <a href="https://github.com/ten1010-io/cncf-certification-challenges/issues/new?title=0019%20-%20%EB%85%B8%EB%93%9C%20NotReady%20%EB%B3%B5%EA%B5%AC%20%28kubelet%20kubeconfig%20%ED%8F%AC%ED%8A%B8%20%EC%98%A4%EB%A5%98%29&labels=answer%2Ccka%2C0019&template=answer.yml" target="_blank"><img src="https://img.shields.io/badge/-Share%20your%20Solution-teal" alt="Share your Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification-challenges/issues?q=label%3Aanswer+label%3A0019" target="_blank"><img src="https://img.shields.io/badge/-Check%20out%20Solutions-de5a77" alt="Check out Solutions"/></a></p><!--info-header-end-->

## 문제

노드 `cka-worker2` 가 `NotReady` 다. kubelet 은 실행 중이다. 원인을 찾아 노드를 `Ready` 로 복구한다.

- 노드를 삭제하거나 재조인하지 말 것.
- 노드 접속: `docker exec -it cka-worker2 bash` (시험의 `ssh node02`).

## 실행

```bash
q start 19      # 환경 구성 + 지문 출력
q check         # 채점
```

로컬(Codespaces 아님)이면 `./bin/q`. 풀이는 `q solution`, 환경 초기화는 `q reset`.

<!--info-footer-start--><br><a href="../../../README.md"><img src="https://img.shields.io/badge/-Back-grey" alt="Back"/></a> <a href="./solution.md"><img src="https://img.shields.io/badge/-Solution%20(spoiler)-red" alt="Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification-challenges/edit/main/cka/questions/0019-hard-node-notready-kubelet-config/README.md"><img src="https://img.shields.io/badge/-Edit-blue" alt="Edit"/></a><!--info-footer-end-->
