<!--info-header-start--><h1>로그와 리소스 모니터링 <img src="https://img.shields.io/badge/-easy-7aad0c" alt="easy"/> <img src="https://img.shields.io/badge/-%23troubleshooting-999" alt="#troubleshooting"/> <img src="https://img.shields.io/badge/-%23logs-999" alt="#logs"/> <img src="https://img.shields.io/badge/-%23metrics-999" alt="#metrics"/> <img src="https://img.shields.io/badge/-%23top-999" alt="#top"/> <img src="https://img.shields.io/badge/-6pt-2b7bb9" alt="6pt"/></h1><p><a href="https://codespaces.new/ten1010-io/cncf-certification?quickstart=1" target="_blank"><img src="https://img.shields.io/badge/-Open%20in%20Codespaces-24292f?logo=github" alt="Open in Codespaces"/></a> <a href="https://github.com/ten1010-io/cncf-certification/issues/new?title=0016%20-%20%EB%A1%9C%EA%B7%B8%EC%99%80%20%EB%A6%AC%EC%86%8C%EC%8A%A4%20%EB%AA%A8%EB%8B%88%ED%84%B0%EB%A7%81&labels=answer%2Ccka%2C0016&template=answer.yml" target="_blank"><img src="https://img.shields.io/badge/-Share%20your%20Solution-teal" alt="Share your Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification/issues?q=label%3Aanswer+label%3A0016" target="_blank"><img src="https://img.shields.io/badge/-Check%20out%20Solutions-de5a77" alt="Check out Solutions"/></a></p><!--info-header-end-->

## 문제

1. 네임스페이스 `default` 의 Pod `crasher` 가 반복 재시작한다. 실패한 컨테이너의 로그 중 `FATAL` 이 포함된 줄을 `/tmp/cncf-out/crasher.log` 에 저장한다.
2. 네임스페이스 `load` 에서 CPU 를 가장 많이 사용하는 Pod 의 **이름만** `/tmp/cncf-out/top-cpu.txt` 에 저장한다.

## 실행

```bash
q start 16      # 환경 구성 + 지문 출력
q check         # 채점
```

로컬(Codespaces 아님)이면 `./bin/q`. 풀이는 `q solution`, 환경 초기화는 `q reset`.

<!--info-footer-start--><br><a href="../../../README.md"><img src="https://img.shields.io/badge/-Back-grey" alt="Back"/></a> <a href="./solution.md"><img src="https://img.shields.io/badge/-Solution%20(spoiler)-red" alt="Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification/edit/main/cka/questions/0016-easy-logs-and-top/README.md"><img src="https://img.shields.io/badge/-Edit-blue" alt="Edit"/></a><!--info-footer-end-->
