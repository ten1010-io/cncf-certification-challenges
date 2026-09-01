# 풀이 — 0007 사이드카 로깅 (emptyDir 공유)

```bash
k run logger --image=busybox:1.36 --dry-run=client -o yaml --command -- sh -c 'while true; do date >> /var/log/app.log; sleep 1; done' > pod.yaml
# 컨테이너 이름 app 으로 변경, shipper 컨테이너와 volumes 추가
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: logger
  namespace: default
spec:
  volumes:
    - name: logs
      emptyDir: {}
  containers:
    - name: app
      image: busybox:1.36
      command: ["sh", "-c", "while true; do date >> /var/log/app.log; sleep 1; done"]
      volumeMounts:
        - {name: logs, mountPath: /var/log}
    - name: shipper
      image: busybox:1.36
      command: ["sh", "-c", "tail -F /var/log/app.log"]
      volumeMounts:
        - {name: logs, mountPath: /var/log}
```

```bash
k apply -f pod.yaml
k logs logger -c shipper --tail=3      # 날짜 줄
```

## 함정

- `tail -f` 는 파일이 아직 없으면 즉시 종료 → shipper 가 CrashLoopBackOff. 파일 생성을 기다리는 `-F` 를 쓴다.
- 두 컨테이너 **모두** 같은 볼륨을 마운트해야 한다. 한쪽만 마운트하면 각자 다른 파일시스템을 본다.
- 컨테이너가 둘이면 `k logs logger` 는 `-c` 없이는 에러. 채점 명령도 `-c shipper`.
- `command` 를 `["date >> ..."]` 처럼 셸 없이 쓰면 리다이렉션이 동작하지 않는다. `sh -c` 로 감싼다.
