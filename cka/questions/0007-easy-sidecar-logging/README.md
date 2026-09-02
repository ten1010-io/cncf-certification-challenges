<!--info-header-start--><h1>사이드카 로깅 (emptyDir 공유) <img src="https://img.shields.io/badge/-easy-7aad0c" alt="easy"/> <img src="https://img.shields.io/badge/-%23workloads-999" alt="#workloads"/> <img src="https://img.shields.io/badge/-%23multi-container-999" alt="#multi-container"/> <img src="https://img.shields.io/badge/-%23emptydir-999" alt="#emptydir"/> <img src="https://img.shields.io/badge/-%23logs-999" alt="#logs"/> <img src="https://img.shields.io/badge/-4pt-2b7bb9" alt="4pt"/></h1><p><a href="https://codespaces.new/ten1010-io/cncf-certification?quickstart=1" target="_blank"><img src="https://img.shields.io/badge/-Open%20in%20Codespaces-24292f?logo=github" alt="Open in Codespaces"/></a> <a href="https://github.com/ten1010-io/cncf-certification/issues/new?title=0007%20-%20%EC%82%AC%EC%9D%B4%EB%93%9C%EC%B9%B4%20%EB%A1%9C%EA%B9%85%20%28emptyDir%20%EA%B3%B5%EC%9C%A0%29&labels=answer%2Ccka%2C0007&template=answer.yml" target="_blank"><img src="https://img.shields.io/badge/-Share%20your%20Solution-teal" alt="Share your Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification/issues?q=label%3Aanswer+label%3A0007" target="_blank"><img src="https://img.shields.io/badge/-Check%20out%20Solutions-de5a77" alt="Check out Solutions"/></a></p><!--info-header-end-->

## 문제

네임스페이스 `default` 에 Pod `logger` 를 생성한다.

- 컨테이너 `app`: 이미지 `busybox:1.36`, 매 1초마다 현재 날짜(`date`)를 `/var/log/app.log` 에 append 한다.
- 컨테이너 `shipper`: 이미지 `busybox:1.36`, `/var/log/app.log` 를 `tail -F` 하여 stdout 으로 출력한다.
- 두 컨테이너는 `emptyDir` 볼륨 `logs` 를 `/var/log` 에 공유한다.

`kubectl logs logger -c shipper` 에 날짜가 출력되어야 한다.

## 실행

```bash
q start 7      # 환경 구성 + 지문 출력
q check         # 채점
```

로컬(Codespaces 아님)이면 `./bin/q`. 풀이는 `q solution`, 환경 초기화는 `q reset`.

<!--info-footer-start--><br><a href="../../../README.md"><img src="https://img.shields.io/badge/-Back-grey" alt="Back"/></a> <a href="./solution.md"><img src="https://img.shields.io/badge/-Solution%20(spoiler)-red" alt="Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification/edit/main/cka/questions/0007-easy-sidecar-logging/README.md"><img src="https://img.shields.io/badge/-Edit-blue" alt="Edit"/></a><!--info-footer-end-->
