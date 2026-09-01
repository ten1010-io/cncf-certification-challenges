<!--info-header-start--><h1>etcd 스냅샷 백업 <img src="https://img.shields.io/badge/-medium-d9901a" alt="medium"/> <img src="https://img.shields.io/badge/-%23cluster-999" alt="#cluster"/> <img src="https://img.shields.io/badge/-%23etcd-999" alt="#etcd"/> <img src="https://img.shields.io/badge/-%23backup-999" alt="#backup"/> <img src="https://img.shields.io/badge/-8pt-2b7bb9" alt="8pt"/></h1><p><a href="https://codespaces.new/ten1010-io/cncf-certification?quickstart=1" target="_blank"><img src="https://img.shields.io/badge/-Open%20in%20Codespaces-24292f?logo=github" alt="Open in Codespaces"/></a> <a href="https://github.com/ten1010-io/cncf-certification/issues/new?title=0013%20-%20etcd%20%EC%8A%A4%EB%83%85%EC%83%B7%20%EB%B0%B1%EC%97%85&labels=answer%2Ccka%2C0013&template=answer.yml" target="_blank"><img src="https://img.shields.io/badge/-Share%20your%20Solution-teal" alt="Share your Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification/issues?q=label%3Aanswer+label%3A0013" target="_blank"><img src="https://img.shields.io/badge/-Check%20out%20Solutions-de5a77" alt="Check out Solutions"/></a></p><!--info-header-end-->

## 문제

control-plane 노드 `cka-control-plane` 에서 실행 중인 etcd 의 스냅샷을 노드의 `/opt/snapshot-01.db` 에 저장한다.

- 노드 접속: `docker exec -it cka-control-plane bash` (시험의 `ssh cp01`). 노드에 `etcdctl`, `etcdutl` 이 설치되어 있다.
- 인증서 위치는 etcd Pod 매니페스트 `/etc/kubernetes/manifests/etcd.yaml` 의 `--cert-file`, `--key-file`, `--trusted-ca-file` 에서 확인한다.
- 저장 후 스냅샷 상태(`snapshot status`)를 확인해 로컬 `/tmp/cncf-out/etcd-status.txt` 에 저장한다.

## 실행

```bash
./bin/q start 0013
./bin/q check 0013
```

<!--info-footer-start--><br><a href="../../../README.md"><img src="https://img.shields.io/badge/-Back-grey" alt="Back"/></a> <a href="./solution.md"><img src="https://img.shields.io/badge/-Solution%20(spoiler)-red" alt="Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification/edit/main/cka/questions/0013-medium-etcd-snapshot/README.md"><img src="https://img.shields.io/badge/-Edit-blue" alt="Edit"/></a><!--info-footer-end-->
