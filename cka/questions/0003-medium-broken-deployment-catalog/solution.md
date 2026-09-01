# 풀이 — 0003 고장난 Deployment 수정

```bash
k -n catalog get po                         # ImagePullBackOff / ErrImagePull
k -n catalog describe po <pod> | tail -20   # Failed to pull image "ngnix:1.25"  ← 오타
k -n catalog set image deploy/catalog catalog=nginx:1.25
k -n catalog get po                         # CreateContainerConfigError
k -n catalog describe po <pod> | tail -20   # configmap "catalog-cfg" not found  ← 두 번째 고장
k -n catalog create cm catalog-cfg --from-literal=ENV=prod
k -n catalog rollout status deploy/catalog  # 2/2
```

CM 을 만드는 대신 `k -n catalog edit deploy catalog` 로 `envFrom` 블록을 제거해도 통과한다. 지문에 CM 언급이 없으면 CM 생성이 더 안전하다(다른 컨테이너가 참조할 수 있다).

## 함정

- 고장이 두 개다. 첫 번째(이미지 오타)를 고치면 그때서야 두 번째(CM 없음)가 드러난다. 매 단계 `describe` 를 다시 본다.
- `ImagePullBackOff` 와 `CreateContainerConfigError` 는 원인이 다르다. 상태 문자열만 보고 짐작하지 말고 Events 를 읽는다.
- `k delete deploy` 후 YAML 로 재생성하면 uid 가 바뀌어 "재생성 금지" 위반 = 0점.
- `set image deploy/catalog nginx=...` 처럼 컨테이너 이름을 잘못 쓰면 조용히 아무 일도 안 일어난다. 컨테이너 이름은 `catalog`.
