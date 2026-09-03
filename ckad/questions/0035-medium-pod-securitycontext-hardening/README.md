<!--info-header-start--><h1>SecurityContext 로 컨테이너 권한 제한 <img src="https://img.shields.io/badge/-medium-d9901a" alt="medium"/> <img src="https://img.shields.io/badge/-%23environment-999" alt="#environment"/> <img src="https://img.shields.io/badge/-%23securitycontext-999" alt="#securitycontext"/> <img src="https://img.shields.io/badge/-%23capabilities-999" alt="#capabilities"/> <img src="https://img.shields.io/badge/-%23pod-999" alt="#pod"/> <img src="https://img.shields.io/badge/-4pt-2b7bb9" alt="4pt"/></h1><p><a href="https://codespaces.new/ten1010-io/cncf-certification-challenges?quickstart=1" target="_blank"><img src="https://img.shields.io/badge/-Open%20in%20Codespaces-24292f?logo=github" alt="Open in Codespaces"/></a> <a href="https://github.com/ten1010-io/cncf-certification-challenges/issues/new?title=0035%20-%20SecurityContext%20%EB%A1%9C%20%EC%BB%A8%ED%85%8C%EC%9D%B4%EB%84%88%20%EA%B6%8C%ED%95%9C%20%EC%A0%9C%ED%95%9C&labels=answer%2Cckad%2C0035&template=answer.yml" target="_blank"><img src="https://img.shields.io/badge/-Share%20your%20Solution-teal" alt="Share your Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification-challenges/issues?q=label%3Aanswer+label%3A0035" target="_blank"><img src="https://img.shields.io/badge/-Check%20out%20Solutions-de5a77" alt="Check out Solutions"/></a></p><!--info-header-end-->

## 문제

네임스페이스 `sec-ctx` 에 Pod `hardened` 를 생성한다.

- 이미지 `busybox:1.36`, 명령 `sleep 3600`
- Pod 레벨: `runAsUser` 1000, `runAsGroup` 3000, `fsGroup` 2000
- 컨테이너 레벨: 권한 상승 금지(`allowPrivilegeEscalation: false`), 루트 파일시스템 읽기 전용(`readOnlyRootFilesystem: true`), 캐퍼빌리티 `NET_ADMIN` 추가

Pod 는 `Running` 이어야 하고, 컨테이너 안에서 `id -u` 가 `1000` 을 출력해야 한다.

## 실행

```bash
q start 35      # 환경 구성 + 지문 출력
q check         # 채점
```

로컬(Codespaces 아님)이면 `./bin/q`. 풀이는 `q solution`, 환경 초기화는 `q reset`.

<!--info-footer-start--><br><a href="../../../README.md"><img src="https://img.shields.io/badge/-Back-grey" alt="Back"/></a> <a href="./solution.md"><img src="https://img.shields.io/badge/-Solution%20(spoiler)-red" alt="Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification-challenges/edit/main/ckad/questions/0035-medium-pod-securitycontext-hardening/README.md"><img src="https://img.shields.io/badge/-Edit-blue" alt="Edit"/></a><!--info-footer-end-->
