<!--info-header-start--><h1>노드 유지보수 (drain) <img src="https://img.shields.io/badge/-easy-7aad0c" alt="easy"/> <img src="https://img.shields.io/badge/-%23cluster-999" alt="#cluster"/> <img src="https://img.shields.io/badge/-%23drain-999" alt="#drain"/> <img src="https://img.shields.io/badge/-%23cordon-999" alt="#cordon"/> <img src="https://img.shields.io/badge/-5pt-2b7bb9" alt="5pt"/></h1><p><a href="https://codespaces.new/ten1010-io/cncf-certification?quickstart=1" target="_blank"><img src="https://img.shields.io/badge/-Open%20in%20Codespaces-24292f?logo=github" alt="Open in Codespaces"/></a> <a href="https://github.com/ten1010-io/cncf-certification/issues/new?title=0033%20-%20%EB%85%B8%EB%93%9C%20%EC%9C%A0%EC%A7%80%EB%B3%B4%EC%88%98%20%28drain%29&labels=answer%2Ccka%2C0033&template=answer.yml" target="_blank"><img src="https://img.shields.io/badge/-Share%20your%20Solution-teal" alt="Share your Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification/issues?q=label%3Aanswer+label%3A0033" target="_blank"><img src="https://img.shields.io/badge/-Check%20out%20Solutions-de5a77" alt="Check out Solutions"/></a></p><!--info-header-end-->

## 문제

노드 `cka-worker2` 를 유지보수 모드로 전환한다.

- 노드의 모든 Pod 를 안전하게 내보낸다 (DaemonSet 관리 Pod 는 무시, emptyDir 데이터 삭제 허용).
- 새 Pod 가 이 노드에 스케줄되지 않게 한다.
- 노드는 그 상태로 둔다 (uncordon 하지 말 것).

## 실행

```bash
q start 33      # 환경 구성 + 지문 출력
q check         # 채점
```

로컬(Codespaces 아님)이면 `./bin/q`. 풀이는 `q solution`, 환경 초기화는 `q reset`.

<!--info-footer-start--><br><a href="../../../README.md"><img src="https://img.shields.io/badge/-Back-grey" alt="Back"/></a> <a href="./solution.md"><img src="https://img.shields.io/badge/-Solution%20(spoiler)-red" alt="Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification/edit/main/cka/questions/0033-easy-node-drain-maintenance/README.md"><img src="https://img.shields.io/badge/-Edit-blue" alt="Edit"/></a><!--info-footer-end-->
