# 풀이 — 0009 기본 StorageClass 변경

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: fast-local
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer
reclaimPolicy: Retain
```

```bash
k apply -f sc.yaml
k patch sc standard -p '{"metadata":{"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'
k get sc        # fast-local (default) / standard
```

문서: "Change the default StorageClass" 태스크 페이지에 patch 명령 그대로 있다.

## 함정

- 어노테이션 값은 문자열 `"true"`. 따옴표 없이 `true` 로 쓰면 YAML 이 bool 로 읽어 `apply` 가 실패한다.
- `standard` 를 해제하지 않으면 기본 SC 가 2개. 지문 "기본에서 해제" 를 채점한다. 값을 `"false"` 로 바꾸거나 어노테이션을 지운다(`... is-default-class-`).
- `provisioner`, `volumeBindingMode`, `reclaimPolicy` 는 생성 후 변경 불가(immutable). 틀리면 삭제 후 재생성.
- 옛 어노테이션 `storageclass.beta.kubernetes.io/is-default-class` 는 채점되지 않는다. 문서의 현재 키를 쓴다.
