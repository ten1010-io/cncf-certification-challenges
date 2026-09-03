# 풀이 — 0035 SecurityContext 로 컨테이너 권한 제한

k create ns sec-ctx
k -n sec-ctx run hardened --image=busybox:1.36 --dry-run=client -o yaml --command -- sleep 3600 > pod.yaml
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: hardened
  namespace: sec-ctx
spec:
  securityContext:
    runAsUser: 1000
    runAsGroup: 3000
    fsGroup: 2000
  containers:
    - name: hardened
      image: busybox:1.36
      command: ["sleep", "3600"]
      securityContext:
        allowPrivilegeEscalation: false
        readOnlyRootFilesystem: true
        capabilities:
          add: ["NET_ADMIN"]
```

```bash
k apply -f pod.yaml
k -n sec-ctx exec hardened -- id       # uid=1000 gid=3000 groups=2000
