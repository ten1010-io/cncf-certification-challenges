<!--info-header-start--><h1>kubeadm control-plane 업그레이드 절차 작성 <img src="https://img.shields.io/badge/-medium-d9901a" alt="medium"/> <img src="https://img.shields.io/badge/-%23cluster-999" alt="#cluster"/> <img src="https://img.shields.io/badge/-%23kubeadm-999" alt="#kubeadm"/> <img src="https://img.shields.io/badge/-%23upgrade-999" alt="#upgrade"/> <img src="https://img.shields.io/badge/-5pt-2b7bb9" alt="5pt"/></h1><p><a href="https://codespaces.new/ten1010-io/cncf-certification?quickstart=1" target="_blank"><img src="https://img.shields.io/badge/-Open%20in%20Codespaces-24292f?logo=github" alt="Open in Codespaces"/></a> <a href="https://github.com/ten1010-io/cncf-certification/issues/new?title=0031%20-%20kubeadm%20control-plane%20%EC%97%85%EA%B7%B8%EB%A0%88%EC%9D%B4%EB%93%9C%20%EC%A0%88%EC%B0%A8%20%EC%9E%91%EC%84%B1&labels=answer%2Ccka%2C0031&template=answer.yml" target="_blank"><img src="https://img.shields.io/badge/-Share%20your%20Solution-teal" alt="Share your Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification/issues?q=label%3Aanswer+label%3A0031" target="_blank"><img src="https://img.shields.io/badge/-Check%20out%20Solutions-de5a77" alt="Check out Solutions"/></a></p><!--info-header-end-->

## 문제

kubeadm 클러스터의 control-plane 노드 `cka-control-plane` 을 v1.34.x 에서 **v1.35.0** 으로 업그레이드하는 전체 명령 시퀀스를 로컬 `/tmp/cncf-out/upgrade-cp.sh` 에 작성한다.

- Ubuntu/apt 기준으로 작성한다 (패키지 저장소 변경, `kubeadm` → `kubeadm upgrade plan/apply` → `kubelet`/`kubectl` 순).
- 노드를 drain 하고 마지막에 uncordon 하는 단계를 포함한다.
- **실행하지 말 것.** 파일만 채점한다.

## 실행

```bash
./bin/q start 0031
./bin/q check 0031
```

<!--info-footer-start--><br><a href="../../../README.md"><img src="https://img.shields.io/badge/-Back-grey" alt="Back"/></a> <a href="./solution.md"><img src="https://img.shields.io/badge/-Solution%20(spoiler)-red" alt="Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification/edit/main/cka/questions/0031-medium-kubeadm-upgrade-plan/README.md"><img src="https://img.shields.io/badge/-Edit-blue" alt="Edit"/></a><!--info-footer-end-->
