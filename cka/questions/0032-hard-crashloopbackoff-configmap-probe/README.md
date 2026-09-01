<!--info-header-start--><h1>CrashLoopBackOff 복구 (ConfigMap 키 + liveness) <img src="https://img.shields.io/badge/-hard-de3d37" alt="hard"/> <img src="https://img.shields.io/badge/-%23troubleshooting-999" alt="#troubleshooting"/> <img src="https://img.shields.io/badge/-%23crashloopbackoff-999" alt="#crashloopbackoff"/> <img src="https://img.shields.io/badge/-%23configmap-999" alt="#configmap"/> <img src="https://img.shields.io/badge/-%23liveness-999" alt="#liveness"/> <img src="https://img.shields.io/badge/-7pt-2b7bb9" alt="7pt"/></h1><p><a href="https://codespaces.new/ten1010-io/cncf-certification?quickstart=1" target="_blank"><img src="https://img.shields.io/badge/-Open%20in%20Codespaces-24292f?logo=github" alt="Open in Codespaces"/></a> <a href="https://github.com/ten1010-io/cncf-certification/issues/new?title=0032%20-%20CrashLoopBackOff%20%EB%B3%B5%EA%B5%AC%20%28ConfigMap%20%ED%82%A4%20%2B%20liveness%29&labels=answer%2Ccka%2C0032&template=answer.yml" target="_blank"><img src="https://img.shields.io/badge/-Share%20your%20Solution-teal" alt="Share your Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification/issues?q=label%3Aanswer+label%3A0032" target="_blank"><img src="https://img.shields.io/badge/-Check%20out%20Solutions-de5a77" alt="Check out Solutions"/></a></p><!--info-header-end-->

## 문제

네임스페이스 `payments` 의 Deployment `payments` 가 계속 재시작한다.

- 앱은 `/config/app.conf` 를 읽어야 하며, 설정은 ConfigMap `payments-cfg` 에서 와야 한다.
- 원인을 **모두** 찾아 Pod 가 `Running` / `Ready` 로 안정되게 한다.
- Deployment 삭제·재생성 금지. ConfigMap 이름 변경 금지. 컨테이너 명령의 `/config/app.conf` 경로는 유지한다.

## 실행

```bash
./bin/q start 0032
./bin/q check 0032
```

<!--info-footer-start--><br><a href="../../../README.md"><img src="https://img.shields.io/badge/-Back-grey" alt="Back"/></a> <a href="./solution.md"><img src="https://img.shields.io/badge/-Solution%20(spoiler)-red" alt="Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification/edit/main/cka/questions/0032-hard-crashloopbackoff-configmap-probe/README.md"><img src="https://img.shields.io/badge/-Edit-blue" alt="Edit"/></a><!--info-footer-end-->
