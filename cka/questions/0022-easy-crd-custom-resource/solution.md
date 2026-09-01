# 풀이 — 0022 CRD 조회와 Custom Resource 생성

```bash
k get crd                                                  # 많다 (calico, gateway api ...). group 으로 걸러야 한다
k get crd -o custom-columns=NAME:.metadata.name,GROUP:.spec.group | grep stable.example.com
k get crd -o jsonpath='{range .items[?(@.spec.group=="stable.example.com")]}{.metadata.name}{"\n"}{end}' > /tmp/cncf-out/crds.txt
cat /tmp/cncf-out/crds.txt                                 # shirts.stable.example.com

k explain shirt                                            # KIND: Shirt, VERSION: stable.example.com/v1
k explain shirt.spec                                       # color <string>, size <string> (enum S M L XL)
cat <<'Y' | k apply -f -
apiVersion: stable.example.com/v1
kind: Shirt
metadata: {name: blue-shirt, namespace: default}
spec:
  color: blue
  size: M
Y
k get shirt blue-shirt -o yaml
```

## 함정

- `k get crd | grep example` 출력을 그대로 저장하면 `NAME  CREATED AT` 두 컬럼이 들어간다. **이름만** 한 줄씩.
- `apiVersion` 은 `<group>/<version>` = `stable.example.com/v1`. `k explain shirt` 의 VERSION 줄이 정답을 알려준다.
- `size` 는 enum. `m` (소문자) 을 쓰면 validation 에 걸려 생성이 거부된다.
