<!--info-header-start--><h1>Deployment + NodePort Service <img src="https://img.shields.io/badge/-easy-7aad0c" alt="easy"/> <img src="https://img.shields.io/badge/-%23workloads-999" alt="#workloads"/> <img src="https://img.shields.io/badge/-%23deployment-999" alt="#deployment"/> <img src="https://img.shields.io/badge/-%23service-999" alt="#service"/> <img src="https://img.shields.io/badge/-%23nodeport-999" alt="#nodeport"/> <img src="https://img.shields.io/badge/-4pt-2b7bb9" alt="4pt"/></h1><p><a href="https://codespaces.new/ten1010-io/cncf-certification-challenges?quickstart=1" target="_blank"><img src="https://img.shields.io/badge/-Open%20in%20Codespaces-24292f?logo=github" alt="Open in Codespaces"/></a> <a href="https://github.com/ten1010-io/cncf-certification-challenges/issues/new?title=0002%20-%20Deployment%20%2B%20NodePort%20Service&labels=answer%2Ccka%2C0002&template=answer.yml" target="_blank"><img src="https://img.shields.io/badge/-Share%20your%20Solution-teal" alt="Share your Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification-challenges/issues?q=label%3Aanswer+label%3A0002" target="_blank"><img src="https://img.shields.io/badge/-Check%20out%20Solutions-de5a77" alt="Check out Solutions"/></a></p><!--info-header-end-->

## 문제

네임스페이스 `frontend` 에 Deployment `web` 을 생성한다.

- 이미지 `nginx:1.25`, replicas 3, 컨테이너 포트 80, Pod 라벨 `app=web`

Deployment 를 Service `web-svc` 로 노출한다.

- type `NodePort`, port 80, targetPort 80, nodePort `30080`
- 3개 Pod 모두 Service 의 엔드포인트여야 한다.

## 실행

```bash
q start 2      # 환경 구성 + 지문 출력
q check         # 채점
```

로컬(Codespaces 아님)이면 `./bin/q`. 풀이는 `q solution`, 환경 초기화는 `q reset`.

<!--info-footer-start--><br><a href="../../../README.md"><img src="https://img.shields.io/badge/-Back-grey" alt="Back"/></a> <a href="./solution.md"><img src="https://img.shields.io/badge/-Solution%20(spoiler)-red" alt="Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification-challenges/edit/main/cka/questions/0002-easy-deployment-nodeport/README.md"><img src="https://img.shields.io/badge/-Edit-blue" alt="Edit"/></a><!--info-footer-end-->
