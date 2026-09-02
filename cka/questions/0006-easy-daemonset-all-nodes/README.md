<!--info-header-start--><h1>DaemonSet 전 노드 배치 <img src="https://img.shields.io/badge/-easy-7aad0c" alt="easy"/> <img src="https://img.shields.io/badge/-%23workloads-999" alt="#workloads"/> <img src="https://img.shields.io/badge/-%23daemonset-999" alt="#daemonset"/> <img src="https://img.shields.io/badge/-%23toleration-999" alt="#toleration"/> <img src="https://img.shields.io/badge/-4pt-2b7bb9" alt="4pt"/></h1><p><a href="https://codespaces.new/ten1010-io/cncf-certification-challenges?quickstart=1" target="_blank"><img src="https://img.shields.io/badge/-Open%20in%20Codespaces-24292f?logo=github" alt="Open in Codespaces"/></a> <a href="https://github.com/ten1010-io/cncf-certification-challenges/issues/new?title=0006%20-%20DaemonSet%20%EC%A0%84%20%EB%85%B8%EB%93%9C%20%EB%B0%B0%EC%B9%98&labels=answer%2Ccka%2C0006&template=answer.yml" target="_blank"><img src="https://img.shields.io/badge/-Share%20your%20Solution-teal" alt="Share your Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification-challenges/issues?q=label%3Aanswer+label%3A0006" target="_blank"><img src="https://img.shields.io/badge/-Check%20out%20Solutions-de5a77" alt="Check out Solutions"/></a></p><!--info-header-end-->

## 문제

네임스페이스 `monitoring` 에 DaemonSet `node-agent` 를 생성한다.

- 이미지 `busybox:1.36`, 명령 `sleep 3600`, Pod 라벨 `app=node-agent`
- control-plane 노드 `cka-control-plane` 을 **포함한 모든** 노드에서 Pod 가 `Running` 이어야 한다.

## 실행

```bash
q start 6      # 환경 구성 + 지문 출력
q check         # 채점
```

로컬(Codespaces 아님)이면 `./bin/q`. 풀이는 `q solution`, 환경 초기화는 `q reset`.

<!--info-footer-start--><br><a href="../../../README.md"><img src="https://img.shields.io/badge/-Back-grey" alt="Back"/></a> <a href="./solution.md"><img src="https://img.shields.io/badge/-Solution%20(spoiler)-red" alt="Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification-challenges/edit/main/cka/questions/0006-easy-daemonset-all-nodes/README.md"><img src="https://img.shields.io/badge/-Edit-blue" alt="Edit"/></a><!--info-footer-end-->
