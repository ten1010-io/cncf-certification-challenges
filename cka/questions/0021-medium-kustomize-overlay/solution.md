# 풀이 — 0021 Kustomize overlay 작성과 적용

```bash
mkdir -p /tmp/cncf-out/kustomize/overlays/prod
cat > /tmp/cncf-out/kustomize/overlays/prod/kustomization.yaml <<'Y'
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
namespace: kprod
namePrefix: prod-
resources:
  - ../../base
replicas:
  - name: web
    count: 3
images:
  - name: nginx
    newTag: "1.25"
Y
k create ns kprod
k kustomize /tmp/cncf-out/kustomize/overlays/prod        # 미리보기: prod-web, replicas 3, nginx:1.25
k apply -k /tmp/cncf-out/kustomize/overlays/prod
k -n kprod get deploy,svc                                 # prod-web 3/3, svc prod-web
```

## 함정

- `resources` 의 base 경로는 overlay 디렉토리 기준 상대경로 `../../base`. base 파일을 복사하지 말고 참조한다.
- `replicas[].name` 과 `images[].name` 은 **base 의 원래 이름**(`web`, `nginx`). prefix 가 붙은 `prod-web` 을 쓰면 매칭이 안 돼 조용히 무시된다.
- `newTag` 는 문자열. `1.25` 를 따옴표 없이 쓰면 YAML 이 숫자로 읽어 에러가 날 수 있다.
- `kubectl apply -f` 가 아니라 **`-k`**. namespace 가 없으면 apply 가 실패하니 먼저 생성한다.
