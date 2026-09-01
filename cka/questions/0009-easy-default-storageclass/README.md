<!--info-header-start--><h1>기본 StorageClass 변경 <img src="https://img.shields.io/badge/-easy-7aad0c" alt="easy"/> <img src="https://img.shields.io/badge/-%23storage-999" alt="#storage"/> <img src="https://img.shields.io/badge/-%23storageclass-999" alt="#storageclass"/> <img src="https://img.shields.io/badge/-4pt-2b7bb9" alt="4pt"/></h1><p><a href="https://codespaces.new/ten1010-io/cncf-certification?quickstart=1" target="_blank"><img src="https://img.shields.io/badge/-Open%20in%20Codespaces-24292f?logo=github" alt="Open in Codespaces"/></a> <a href="https://github.com/ten1010-io/cncf-certification/issues/new?title=0009%20-%20%EA%B8%B0%EB%B3%B8%20StorageClass%20%EB%B3%80%EA%B2%BD&labels=answer%2Ccka%2C0009&template=answer.yml" target="_blank"><img src="https://img.shields.io/badge/-Share%20your%20Solution-teal" alt="Share your Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification/issues?q=label%3Aanswer+label%3A0009" target="_blank"><img src="https://img.shields.io/badge/-Check%20out%20Solutions-de5a77" alt="Check out Solutions"/></a></p><!--info-header-end-->

## 문제

StorageClass `fast-local` 을 생성한다.

- provisioner `kubernetes.io/no-provisioner`
- volumeBindingMode `WaitForFirstConsumer`
- reclaimPolicy `Retain`

`fast-local` 을 클러스터의 **기본** StorageClass 로 설정하고, 기존 기본 StorageClass `standard` 는 기본에서 해제한다. 기본 StorageClass 는 하나만 있어야 한다.

## 실행

```bash
./bin/q start 0009
./bin/q check 0009
```

<!--info-footer-start--><br><a href="../../../README.md"><img src="https://img.shields.io/badge/-Back-grey" alt="Back"/></a> <a href="./solution.md"><img src="https://img.shields.io/badge/-Solution%20(spoiler)-red" alt="Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification/edit/main/cka/questions/0009-easy-default-storageclass/README.md"><img src="https://img.shields.io/badge/-Edit-blue" alt="Edit"/></a><!--info-footer-end-->
