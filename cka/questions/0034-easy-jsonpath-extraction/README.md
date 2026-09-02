<!--info-header-start--><h1>jsonpath / sort-by 정보 추출 <img src="https://img.shields.io/badge/-easy-7aad0c" alt="easy"/> <img src="https://img.shields.io/badge/-%23troubleshooting-999" alt="#troubleshooting"/> <img src="https://img.shields.io/badge/-%23jsonpath-999" alt="#jsonpath"/> <img src="https://img.shields.io/badge/-%23sort-by-999" alt="#sort-by"/> <img src="https://img.shields.io/badge/-5pt-2b7bb9" alt="5pt"/></h1><p><a href="https://codespaces.new/ten1010-io/cncf-certification?quickstart=1" target="_blank"><img src="https://img.shields.io/badge/-Open%20in%20Codespaces-24292f?logo=github" alt="Open in Codespaces"/></a> <a href="https://github.com/ten1010-io/cncf-certification/issues/new?title=0034%20-%20jsonpath%20/%20sort-by%20%EC%A0%95%EB%B3%B4%20%EC%B6%94%EC%B6%9C&labels=answer%2Ccka%2C0034&template=answer.yml" target="_blank"><img src="https://img.shields.io/badge/-Share%20your%20Solution-teal" alt="Share your Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification/issues?q=label%3Aanswer+label%3A0034" target="_blank"><img src="https://img.shields.io/badge/-Check%20out%20Solutions-de5a77" alt="Check out Solutions"/></a></p><!--info-header-end-->

## 문제

1. 모든 노드의 `이름 InternalIP` 를 한 줄에 하나씩 로컬 `/tmp/cncf-out/node-ips.txt` 에 저장한다 (예: `cka-control-plane 172.18.0.2`). `kubectl` 의 jsonpath 또는 custom-columns 를 사용한다.
2. 클러스터의 모든 PersistentVolume 을 **용량 오름차순**으로 정렬한 `kubectl get pv --sort-by=...` 결과를 로컬 `/tmp/cncf-out/pv-sorted.txt` 에 저장한다.

## 실행

```bash
q start 34      # 환경 구성 + 지문 출력
q check         # 채점
```

로컬(Codespaces 아님)이면 `./bin/q`. 풀이는 `q solution`, 환경 초기화는 `q reset`.

<!--info-footer-start--><br><a href="../../../README.md"><img src="https://img.shields.io/badge/-Back-grey" alt="Back"/></a> <a href="./solution.md"><img src="https://img.shields.io/badge/-Solution%20(spoiler)-red" alt="Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification/edit/main/cka/questions/0034-easy-jsonpath-extraction/README.md"><img src="https://img.shields.io/badge/-Edit-blue" alt="Edit"/></a><!--info-footer-end-->
