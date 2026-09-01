# 풀이 — 0032 CrashLoopBackOff 복구 (ConfigMap 키 + liveness)

```bash
k -n payments get po -l app=payments                 # CrashLoopBackOff
k -n payments logs -l app=payments --previous        # cat: can't open '/config/app.conf': No such file or directory
k -n payments get cm payments-cfg -o yaml            # data 키가 settings.conf  ← 고장 1
k -n payments describe po -l app=payments | grep -A3 Liveness
#   Liveness: http-get http://:80/healthz ...  ← 고장 2 (busybox 는 80 포트를 열지 않음)
```

### 고장 1: ConfigMap 키 이름

키를 `app.conf` 로 바꾼다 (이름은 그대로 `payments-cfg`).

```bash
k -n payments create cm payments-cfg --from-literal=app.conf="mode=prod" --dry-run=client -o yaml | k replace -f -
```

또는 CM 은 두고 Deployment 볼륨에서 키를 매핑:

```yaml
volumes:
  - name: cfg
    configMap:
      name: payments-cfg
      items: [{key: settings.conf, path: app.conf}]
```

### 고장 2: liveness probe

```bash
k -n payments edit deploy payments
```

`livenessProbe` 블록을 삭제하거나 exec 로 교체:

```yaml
livenessProbe:
  exec: {command: ["cat", "/config/app.conf"]}
  initialDelaySeconds: 5
  periodSeconds: 5
```

```bash
k -n payments rollout status deploy payments
k -n payments get po -l app=payments                 # Running 1/1, RESTARTS 0
```

## 함정

- 첫 원인(CM 키)만 고치면 컨테이너는 뜨지만 15초 뒤 liveness 실패로 다시 재시작한다. "원인을 모두" = 로그와 describe 를 둘 다 본다.
- `k logs` 가 비어 있으면 `--previous` 로 죽은 컨테이너 로그를 본다.
- CM 을 `k delete` + `create` 로 다시 만들어도 되지만 `k edit cm` 에서 키 이름을 직접 바꾸는 게 빠르다. 이름을 바꾸면(예: `payments-cfg2`) 지문 위반.
- Deployment 를 지우고 다시 만들면 uid 가 바뀌어 채점 실패. `edit`/`patch`/`set` 으로만 수정.
