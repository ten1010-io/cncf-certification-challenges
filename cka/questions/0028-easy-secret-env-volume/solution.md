# 풀이 — 0028 Secret 환경변수·볼륨 주입

```bash
k -n secure-app create secret generic db-creds --from-literal=username=admin --from-literal=password=s3cr3t
k -n secure-app run secure-app --image=busybox:1.36 --dry-run=client -o yaml --command -- sleep 3600 > pod.yaml
```

`pod.yaml` 에 env 와 volume 추가:

```yaml
apiVersion: v1
kind: Pod
metadata: {name: secure-app, namespace: secure-app}
spec:
  volumes:
    - name: creds
      secret: {secretName: db-creds}
  containers:
    - name: secure-app
      image: busybox:1.36
      command: ["sleep","3600"]
      env:
        - name: DB_USER
          valueFrom: {secretKeyRef: {name: db-creds, key: username}}
      volumeMounts:
        - {name: creds, mountPath: /etc/creds, readOnly: true}
```

```bash
k apply -f pod.yaml
k -n secure-app exec secure-app -- sh -c 'echo $DB_USER; cat /etc/creds/password'
```

## 함정

- 환경변수는 `valueFrom.secretKeyRef` 다. `configMapKeyRef` 와 혼동하면 Pod 가 `CreateContainerConfigError`.
- `readOnly: true` 는 `volumeMounts` 쪽에 쓴다. `volumes.secret` 에는 그 필드가 없다.
- `--from-literal` 값에 특수문자(`$`, `!`) 가 있으면 셸이 먹으니 작은따옴표로 감싼다.
