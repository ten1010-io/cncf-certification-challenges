<!--info-header-start--><h1>컨트롤플레인 장애 (kube-scheduler 매니페스트) <img src="https://img.shields.io/badge/-hard-de3d37" alt="hard"/> <img src="https://img.shields.io/badge/-%23troubleshooting-999" alt="#troubleshooting"/> <img src="https://img.shields.io/badge/-%23static-pod-999" alt="#static-pod"/> <img src="https://img.shields.io/badge/-%23kube-scheduler-999" alt="#kube-scheduler"/> <img src="https://img.shields.io/badge/-%23control-plane-999" alt="#control-plane"/> <img src="https://img.shields.io/badge/-8pt-2b7bb9" alt="8pt"/></h1><p><a href="https://codespaces.new/ten1010-io/cncf-certification-challenges?quickstart=1" target="_blank"><img src="https://img.shields.io/badge/-Open%20in%20Codespaces-24292f?logo=github" alt="Open in Codespaces"/></a> <a href="https://github.com/ten1010-io/cncf-certification-challenges/issues/new?title=0018%20-%20%EC%BB%A8%ED%8A%B8%EB%A1%A4%ED%94%8C%EB%A0%88%EC%9D%B8%20%EC%9E%A5%EC%95%A0%20%28kube-scheduler%20%EB%A7%A4%EB%8B%88%ED%8E%98%EC%8A%A4%ED%8A%B8%29&labels=answer%2Ccka%2C0018&template=answer.yml" target="_blank"><img src="https://img.shields.io/badge/-Share%20your%20Solution-teal" alt="Share your Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification-challenges/issues?q=label%3Aanswer+label%3A0018" target="_blank"><img src="https://img.shields.io/badge/-Check%20out%20Solutions-de5a77" alt="Check out Solutions"/></a></p><!--info-header-end-->

## 문제

네임스페이스 `sched-test` 의 Deployment `pending-app` 의 Pod 가 `Pending` 상태로 스케줄되지 않는다.

컨트롤플레인 컴포넌트를 점검해 원인을 고치고 Pod 가 `Running` 되게 한다. Deployment 는 수정하지 말 것.

- 노드 접속: `docker exec -it cka-control-plane bash` (시험의 `ssh cp01`).
- 이 환경에서는 스케줄러가 죽어 있어 새 Pod 가 어디에도 스케줄되지 않는다. 모의고사에서는 이 문제를 먼저 푼다.

## 실행

```bash
q start 18      # 환경 구성 + 지문 출력
q check         # 채점
```

로컬(Codespaces 아님)이면 `./bin/q`. 풀이는 `q solution`, 환경 초기화는 `q reset`.

<!--info-footer-start--><br><a href="../../../README.md"><img src="https://img.shields.io/badge/-Back-grey" alt="Back"/></a> <a href="./solution.md"><img src="https://img.shields.io/badge/-Solution%20(spoiler)-red" alt="Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification-challenges/edit/main/cka/questions/0018-hard-kube-scheduler-manifest-broken/README.md"><img src="https://img.shields.io/badge/-Edit-blue" alt="Edit"/></a><!--info-footer-end-->
