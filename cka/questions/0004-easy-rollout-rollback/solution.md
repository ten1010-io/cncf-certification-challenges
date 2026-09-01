# 풀이 — 0004 롤링 업데이트와 롤백

```bash
k -n api get deploy api -o jsonpath='{.spec.template.spec.containers[*].name}'   # nginx  (컨테이너 이름 확인)
k -n api set image deploy/api nginx=nginx:1.25
k -n api rollout status deploy/api
k -n api rollout history deploy/api          # revision 1, 2
k -n api rollout undo deploy/api             # 직전 버전(revision 1)으로. revision 3 생성
k -n api rollout status deploy/api
k -n api rollout history deploy/api          # 2, 3  (1 은 3 으로 이동)
k -n api get deploy api -o jsonpath='{.spec.template.spec.containers[0].image}'   # nginx:1.24
```

## 함정

- `create deploy` 로 만든 Deployment 의 컨테이너 이름은 이미지 이름(`nginx`)이다. `set image deploy/api api=...` 는 컨테이너가 없어 무시된다.
- `set image` 대신 `edit` 로 이미지를 1.24 로 되돌리면 이미지는 맞아도 "롤백" 이 아니다. 채점은 revision 3 이상과 1.25 ReplicaSet 의 존재를 본다. (`edit` 로 되돌려도 revision 은 오르지만 시험에선 `rollout undo` 를 쓸 것.)
- `rollout undo --to-revision=N` 은 특정 버전 지정. 지문이 "직전 버전" 이면 옵션 없이 `undo`.
- 삭제 후 재생성하면 히스토리가 사라지고 uid 가 바뀐다.
