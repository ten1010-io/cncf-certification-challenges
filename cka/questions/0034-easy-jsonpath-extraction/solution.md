# 풀이 — 0034 jsonpath / sort-by 정보 추출

```bash
k get no -o jsonpath='{range .items[*]}{.metadata.name} {.status.addresses[?(@.type=="InternalIP")].address}{"\n"}{end}' \
  > /tmp/cncf-out/node-ips.txt
cat /tmp/cncf-out/node-ips.txt
#   cka-control-plane 172.18.0.2
#   cka-worker 172.18.0.3
#   cka-worker2 172.18.0.4

k get pv --sort-by=.spec.capacity.storage > /tmp/cncf-out/pv-sorted.txt
cat /tmp/cncf-out/pv-sorted.txt      # pv-b 1Gi, pv-c 2Gi, pv-a 3Gi 순
```

custom-columns 로도 가능하지만 헤더가 붙는다 (`--no-headers` 필요):

```bash
k get no -o custom-columns='NAME:.metadata.name,IP:.status.addresses[?(@.type=="InternalIP")].address' --no-headers
```

## 함정

- jsonpath 의 `range` 안에서 `{"\n"}` 을 빼면 모든 노드가 한 줄로 붙는다. 지문은 "한 줄에 하나씩".
- `.status.addresses[0].address` 는 순서에 의존한다. `[?(@.type=="InternalIP")]` 필터로 타입을 지정한다.
- `--sort-by` 는 jsonpath 표현식을 받는다 (`.spec.capacity.storage`). `capacity` 만 쓰거나 `-o` 필드명을 쓰면 오류. 용량은 수량(quantity) 으로 비교되어 `1Gi < 2Gi < 3Gi` 로 정렬된다.
- `--sort-by` 결과에 다른 PV(예: 다른 문항의 `pv-logs`) 가 섞여도 된다. 채점은 `pv-a/b/c` 의 상대 순서만 본다.
