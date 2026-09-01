<!--info-header-start--><h1>CoreDNS Corefile 복구 (DNS 장애) <img src="https://img.shields.io/badge/-hard-de3d37" alt="hard"/> <img src="https://img.shields.io/badge/-%23troubleshooting-999" alt="#troubleshooting"/> <img src="https://img.shields.io/badge/-%23coredns-999" alt="#coredns"/> <img src="https://img.shields.io/badge/-%23dns-999" alt="#dns"/> <img src="https://img.shields.io/badge/-8pt-2b7bb9" alt="8pt"/></h1><p><a href="https://codespaces.new/ten1010-io/cncf-certification?quickstart=1" target="_blank"><img src="https://img.shields.io/badge/-Open%20in%20Codespaces-24292f?logo=github" alt="Open in Codespaces"/></a> <a href="https://github.com/ten1010-io/cncf-certification/issues/new?title=0015%20-%20CoreDNS%20Corefile%20%EB%B3%B5%EA%B5%AC%20%28DNS%20%EC%9E%A5%EC%95%A0%29&labels=answer%2Ccka%2C0015&template=answer.yml" target="_blank"><img src="https://img.shields.io/badge/-Share%20your%20Solution-teal" alt="Share your Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification/issues?q=label%3Aanswer+label%3A0015" target="_blank"><img src="https://img.shields.io/badge/-Check%20out%20Solutions-de5a77" alt="Check out Solutions"/></a></p><!--info-header-end-->

## 문제

클러스터 내부에서 Service 이름 해석이 실패한다. 예:

```
kubectl run test --rm -it --image=busybox:1.36 --restart=Never -- nslookup kubernetes.default.svc.cluster.local
```

원인을 찾아 수정한다. CoreDNS Deployment 를 삭제·재생성하지 말 것.

## 실행

```bash
./bin/q start 0015
./bin/q check 0015
```

<!--info-footer-start--><br><a href="../../../README.md"><img src="https://img.shields.io/badge/-Back-grey" alt="Back"/></a> <a href="./solution.md"><img src="https://img.shields.io/badge/-Solution%20(spoiler)-red" alt="Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification/edit/main/cka/questions/0015-hard-coredns-corefile-broken/README.md"><img src="https://img.shields.io/badge/-Edit-blue" alt="Edit"/></a><!--info-footer-end-->
