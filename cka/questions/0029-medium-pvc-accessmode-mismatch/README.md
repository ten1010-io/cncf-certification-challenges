<!--info-header-start--><h1>PVC Pending (accessModes 불일치) <img src="https://img.shields.io/badge/-medium-d9901a" alt="medium"/> <img src="https://img.shields.io/badge/-%23storage-999" alt="#storage"/> <img src="https://img.shields.io/badge/-%23pv-999" alt="#pv"/> <img src="https://img.shields.io/badge/-%23pvc-999" alt="#pvc"/> <img src="https://img.shields.io/badge/-%23accessmodes-999" alt="#accessmodes"/> <img src="https://img.shields.io/badge/-7pt-2b7bb9" alt="7pt"/></h1><p><a href="https://codespaces.new/ten1010-io/cncf-certification?quickstart=1" target="_blank"><img src="https://img.shields.io/badge/-Open%20in%20Codespaces-24292f?logo=github" alt="Open in Codespaces"/></a> <a href="https://github.com/ten1010-io/cncf-certification/issues/new?title=0029%20-%20PVC%20Pending%20%28accessModes%20%EB%B6%88%EC%9D%BC%EC%B9%98%29&labels=answer%2Ccka%2C0029&template=answer.yml" target="_blank"><img src="https://img.shields.io/badge/-Share%20your%20Solution-teal" alt="Share your Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification/issues?q=label%3Aanswer+label%3A0029" target="_blank"><img src="https://img.shields.io/badge/-Check%20out%20Solutions-de5a77" alt="Check out Solutions"/></a></p><!--info-header-end-->

## 문제

네임스페이스 `logs` 의 PVC `logs-pvc` 가 `Pending` 이고 Pod `log-writer` 가 기동하지 않는다.

- PV `pv-logs` 는 수정하지 말 것.
- PVC 를 수정(필요시 삭제 후 재생성)해 `pv-logs` 에 Bound 시킨다.
- Pod `log-writer` 가 `Running` 이 되게 한다 (Pod 는 삭제 후 동일 spec 으로 재생성 가능).

## 실행

```bash
./bin/q start 0029
./bin/q check 0029
```

<!--info-footer-start--><br><a href="../../../README.md"><img src="https://img.shields.io/badge/-Back-grey" alt="Back"/></a> <a href="./solution.md"><img src="https://img.shields.io/badge/-Solution%20(spoiler)-red" alt="Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification/edit/main/cka/questions/0029-medium-pvc-accessmode-mismatch/README.md"><img src="https://img.shields.io/badge/-Edit-blue" alt="Edit"/></a><!--info-footer-end-->
