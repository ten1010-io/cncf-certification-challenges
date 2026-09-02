<!--info-header-start--><h1>taint/toleration + nodeSelector 스케줄링 <img src="https://img.shields.io/badge/-medium-d9901a" alt="medium"/> <img src="https://img.shields.io/badge/-%23workloads-999" alt="#workloads"/> <img src="https://img.shields.io/badge/-%23taint-999" alt="#taint"/> <img src="https://img.shields.io/badge/-%23toleration-999" alt="#toleration"/> <img src="https://img.shields.io/badge/-%23nodeselector-999" alt="#nodeselector"/> <img src="https://img.shields.io/badge/-6pt-2b7bb9" alt="6pt"/></h1><p><a href="https://codespaces.new/ten1010-io/cncf-certification-challenges?quickstart=1" target="_blank"><img src="https://img.shields.io/badge/-Open%20in%20Codespaces-24292f?logo=github" alt="Open in Codespaces"/></a> <a href="https://github.com/ten1010-io/cncf-certification-challenges/issues/new?title=0005%20-%20taint/toleration%20%2B%20nodeSelector%20%EC%8A%A4%EC%BC%80%EC%A4%84%EB%A7%81&labels=answer%2Ccka%2C0005&template=answer.yml" target="_blank"><img src="https://img.shields.io/badge/-Share%20your%20Solution-teal" alt="Share your Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification-challenges/issues?q=label%3Aanswer+label%3A0005" target="_blank"><img src="https://img.shields.io/badge/-Check%20out%20Solutions-de5a77" alt="Check out Solutions"/></a></p><!--info-header-end-->

## 문제

노드 `cka-worker` 에는 taint `dedicated=batch:NoSchedule` 과 라벨 `workload=batch` 가 있다.

네임스페이스 `batch` 에 Pod `batch-runner` 를 생성한다.

- 이미지 `busybox:1.36`, 명령 `sleep 3600`
- **반드시** `cka-worker` 에 스케줄되어 `Running` 이어야 한다.
- `nodeName` 은 사용하지 말 것.

## 실행

```bash
q start 5      # 환경 구성 + 지문 출력
q check         # 채점
```

로컬(Codespaces 아님)이면 `./bin/q`. 풀이는 `q solution`, 환경 초기화는 `q reset`.

<!--info-footer-start--><br><a href="../../../README.md"><img src="https://img.shields.io/badge/-Back-grey" alt="Back"/></a> <a href="./solution.md"><img src="https://img.shields.io/badge/-Solution%20(spoiler)-red" alt="Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification-challenges/edit/main/cka/questions/0005-medium-taint-toleration-scheduling/README.md"><img src="https://img.shields.io/badge/-Edit-blue" alt="Edit"/></a><!--info-footer-end-->
