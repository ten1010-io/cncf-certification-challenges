<!--info-header-start--><h1>Job 과 CronJob 생성 <img src="https://img.shields.io/badge/-easy-7aad0c" alt="easy"/> <img src="https://img.shields.io/badge/-%23workloads-999" alt="#workloads"/> <img src="https://img.shields.io/badge/-%23job-999" alt="#job"/> <img src="https://img.shields.io/badge/-%23cronjob-999" alt="#cronjob"/> <img src="https://img.shields.io/badge/-4pt-2b7bb9" alt="4pt"/></h1><p><a href="https://codespaces.new/ten1010-io/cncf-certification?quickstart=1" target="_blank"><img src="https://img.shields.io/badge/-Open%20in%20Codespaces-24292f?logo=github" alt="Open in Codespaces"/></a> <a href="https://github.com/ten1010-io/cncf-certification/issues/new?title=0023%20-%20Job%20%EA%B3%BC%20CronJob%20%EC%83%9D%EC%84%B1&labels=answer%2Ccka%2C0023&template=answer.yml" target="_blank"><img src="https://img.shields.io/badge/-Share%20your%20Solution-teal" alt="Share your Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification/issues?q=label%3Aanswer+label%3A0023" target="_blank"><img src="https://img.shields.io/badge/-Check%20out%20Solutions-de5a77" alt="Check out Solutions"/></a></p><!--info-header-end-->

## 문제

네임스페이스 `jobs` 에 다음을 생성한다.

- Job `countdown`: 이미지 `busybox:1.36`, 명령 `sh -c "for i in 5 4 3 2 1; do echo $i; sleep 1; done"`, `completions: 3`, `parallelism: 1`, `backoffLimit: 2`
- CronJob `cleanup`: 스케줄 `*/5 * * * *`, 이미지 `busybox:1.36`, 명령 `echo cleanup`, `concurrencyPolicy: Forbid`, `successfulJobsHistoryLimit: 2`

Job `countdown` 은 3회 모두 성공 완료되어야 한다.

## 실행

```bash
q start 23      # 환경 구성 + 지문 출력
q check         # 채점
```

로컬(Codespaces 아님)이면 `./bin/q`. 풀이는 `q solution`, 환경 초기화는 `q reset`.

<!--info-footer-start--><br><a href="../../../README.md"><img src="https://img.shields.io/badge/-Back-grey" alt="Back"/></a> <a href="./solution.md"><img src="https://img.shields.io/badge/-Solution%20(spoiler)-red" alt="Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification/edit/main/cka/questions/0023-easy-job-cronjob/README.md"><img src="https://img.shields.io/badge/-Edit-blue" alt="Edit"/></a><!--info-footer-end-->
