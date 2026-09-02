<!--info-header-start--><h1>NetworkPolicy — frontend 만 허용 <img src="https://img.shields.io/badge/-medium-d9901a" alt="medium"/> <img src="https://img.shields.io/badge/-%23networking-999" alt="#networking"/> <img src="https://img.shields.io/badge/-%23networkpolicy-999" alt="#networkpolicy"/> <img src="https://img.shields.io/badge/-7pt-2b7bb9" alt="7pt"/></h1><p><a href="https://codespaces.new/ten1010-io/cncf-certification-challenges?quickstart=1" target="_blank"><img src="https://img.shields.io/badge/-Open%20in%20Codespaces-24292f?logo=github" alt="Open in Codespaces"/></a> <a href="https://github.com/ten1010-io/cncf-certification-challenges/issues/new?title=0010%20-%20NetworkPolicy%20%E2%80%94%20frontend%20%EB%A7%8C%20%ED%97%88%EC%9A%A9&labels=answer%2Ccka%2C0010&template=answer.yml" target="_blank"><img src="https://img.shields.io/badge/-Share%20your%20Solution-teal" alt="Share your Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification-challenges/issues?q=label%3Aanswer+label%3A0010" target="_blank"><img src="https://img.shields.io/badge/-Check%20out%20Solutions-de5a77" alt="Check out Solutions"/></a></p><!--info-header-end-->

## 문제

네임스페이스 `np-backend` 에 Pod `db`(라벨 `app=db`, 포트 80) 가 있다. 네임스페이스 `np-frontend` 에는 라벨 `app=web` 인 Pod `web` 이, 네임스페이스 `np-other` 에는 그 밖의 Pod 들이 있다.

네임스페이스 `np-backend` 에 NetworkPolicy `db-allow-web` 을 생성한다.

- `app=db` Pod 로의 ingress 를 **`np-frontend` 네임스페이스의 `app=web` 라벨 Pod** 에서 오는 TCP 80 만 허용한다.
- 그 외 모든 ingress 는 차단된다. 다른 네임스페이스의 Pod 는 라벨이 무엇이든 차단되어야 한다.
- egress 는 제한하지 않는다. 기존 다른 정책은 수정하지 않는다.

## 실행

```bash
q start 10      # 환경 구성 + 지문 출력
q check         # 채점
```

로컬(Codespaces 아님)이면 `./bin/q`. 풀이는 `q solution`, 환경 초기화는 `q reset`.

<!--info-footer-start--><br><a href="../../../README.md"><img src="https://img.shields.io/badge/-Back-grey" alt="Back"/></a> <a href="./solution.md"><img src="https://img.shields.io/badge/-Solution%20(spoiler)-red" alt="Solution"/></a> <a href="https://github.com/ten1010-io/cncf-certification-challenges/edit/main/cka/questions/0010-medium-networkpolicy-allow-frontend/README.md"><img src="https://img.shields.io/badge/-Edit-blue" alt="Edit"/></a><!--info-footer-end-->
