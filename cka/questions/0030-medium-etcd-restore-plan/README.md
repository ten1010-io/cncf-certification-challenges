<!--info-header-start--><h1>etcd 스냅샷 + 복원 절차 작성 <img src="https://img.shields.io/badge/-medium-d9901a" alt="medium"/> <img src="https://img.shields.io/badge/-%23cluster-999" alt="#cluster"/> <img src="https://img.shields.io/badge/-%23etcd-999" alt="#etcd"/> <img src="https://img.shields.io/badge/-%23restore-999" alt="#restore"/> <img src="https://img.shields.io/badge/-5pt-2b7bb9" alt="5pt"/></h1><p><a href="https://codespaces.new/ten1010-io/cncf-certification?quickstart=1" target="_blank"><img src="https://img.shields.io/badge/-Open%20in%20Codespaces-24292f?logo=github" alt="Open in Codespaces"/></a> <a href="https://github.com/ten1010-io/cncf-certification/issues/new?title=0030%20-%20etcd%20%EC%8A%A4%EB%83%85%EC%83%B7%20%2B%20%EB%B3%B5%EC%9B%90%20%EC%A0%88%EC%B0%A8%20%EC%9E%91%EC%84%B1&labels=answer%2Ccka%2C0030&template=answer.yml" target="_blank"><img src="https://img.shields.io/badge/-Share%20your%20Solution-teal" alt="Share your Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification/issues?q=label%3Aanswer+label%3A0030" target="_blank"><img src="https://img.shields.io/badge/-Check%20out%20Solutions-de5a77" alt="Check out Solutions"/></a></p><!--info-header-end-->

## 문제

1. control-plane 노드 `cka-control-plane` 에서 실행 중인 etcd 의 스냅샷을 노드의 `/opt/snapshot-02.db` 에 저장한다.
   - 노드 접속: `docker exec -it cka-control-plane bash` (시험의 `ssh cp01`). 노드에 `etcdctl`, `etcdutl` 이 설치되어 있다.
   - 인증서 위치는 etcd Pod 매니페스트 `/etc/kubernetes/manifests/etcd.yaml` 의 `--cert-file`, `--key-file`, `--trusted-ca-file` 에서 확인한다.
2. 이 스냅샷을 **새 데이터 디렉토리 `/var/lib/etcd-restore`** 로 복원하고 etcd 가 그 디렉토리를 쓰게 만드는 절차를 로컬 `/tmp/cncf-out/etcd-restore.sh` 에 작성한다. **실행하지 말 것.**
   - kubeadm 클러스터 기준(인증서 `/etc/kubernetes/pki/etcd/`, 매니페스트 `/etc/kubernetes/manifests/etcd.yaml`, 현재 데이터 디렉토리 `/var/lib/etcd`)으로 작성한다.

## 실행

```bash
q start 30      # 환경 구성 + 지문 출력
q check         # 채점
```

로컬(Codespaces 아님)이면 `./bin/q`. 풀이는 `q solution`, 환경 초기화는 `q reset`.

<!--info-footer-start--><br><a href="../../../README.md"><img src="https://img.shields.io/badge/-Back-grey" alt="Back"/></a> <a href="./solution.md"><img src="https://img.shields.io/badge/-Solution%20(spoiler)-red" alt="Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification/edit/main/cka/questions/0030-medium-etcd-restore-plan/README.md"><img src="https://img.shields.io/badge/-Edit-blue" alt="Edit"/></a><!--info-footer-end-->
