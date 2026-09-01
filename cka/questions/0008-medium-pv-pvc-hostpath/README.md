<!--info-header-start--><h1>PV / PVC (hostPath, manual) <img src="https://img.shields.io/badge/-medium-d9901a" alt="medium"/> <img src="https://img.shields.io/badge/-%23storage-999" alt="#storage"/> <img src="https://img.shields.io/badge/-%23pv-999" alt="#pv"/> <img src="https://img.shields.io/badge/-%23pvc-999" alt="#pvc"/> <img src="https://img.shields.io/badge/-%23hostpath-999" alt="#hostpath"/> <img src="https://img.shields.io/badge/-7pt-2b7bb9" alt="7pt"/></h1><p><a href="https://codespaces.new/ten1010-io/cncf-certification?quickstart=1" target="_blank"><img src="https://img.shields.io/badge/-Open%20in%20Codespaces-24292f?logo=github" alt="Open in Codespaces"/></a> <a href="https://github.com/ten1010-io/cncf-certification/issues/new?title=0008%20-%20PV%20/%20PVC%20%28hostPath%2C%20manual%29&labels=answer%2Ccka%2C0008&template=answer.yml" target="_blank"><img src="https://img.shields.io/badge/-Share%20your%20Solution-teal" alt="Share your Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification/issues?q=label%3Aanswer+label%3A0008" target="_blank"><img src="https://img.shields.io/badge/-Check%20out%20Solutions-de5a77" alt="Check out Solutions"/></a></p><!--info-header-end-->

## 문제

다음을 생성한다.

- PersistentVolume `pv-orders`: 용량 `1Gi`, accessMode `ReadWriteOnce`, `storageClassName: manual`, reclaimPolicy `Retain`, `hostPath` `/mnt/orders`
- 네임스페이스 `orders` 에 PersistentVolumeClaim `orders-pvc`: 요청 `500Mi`, accessMode `ReadWriteOnce`, `storageClassName: manual`
- 네임스페이스 `orders` 에 Pod `orders-db`: 이미지 `busybox:1.36`, 명령 `sleep 3600`, `orders-pvc` 를 `/data` 에 마운트

PVC 는 `pv-orders` 에 `Bound` 되어야 하고 Pod 는 `Running` 이어야 한다. (`/mnt/orders` 디렉토리는 모든 노드에 미리 만들어져 있다.)

## 실행

```bash
./bin/q start 0008
./bin/q check 0008
```

<!--info-footer-start--><br><a href="../../../README.md"><img src="https://img.shields.io/badge/-Back-grey" alt="Back"/></a> <a href="./solution.md"><img src="https://img.shields.io/badge/-Solution%20(spoiler)-red" alt="Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification/edit/main/cka/questions/0008-medium-pv-pvc-hostpath/README.md"><img src="https://img.shields.io/badge/-Edit-blue" alt="Edit"/></a><!--info-footer-end-->
