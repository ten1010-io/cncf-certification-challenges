# 풀이 — 0008 PV / PVC (hostPath, manual)

PV/PVC 는 `k create` 명령이 없다. 문서(Configure a Pod to Use a PersistentVolume for Storage)의 예제를 복사해 고친다.

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-orders
spec:
  capacity: {storage: 1Gi}
  accessModes: [ReadWriteOnce]
  persistentVolumeReclaimPolicy: Retain
  storageClassName: manual
  hostPath: {path: /mnt/orders}
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: orders-pvc
  namespace: orders
spec:
  accessModes: [ReadWriteOnce]
  storageClassName: manual
  resources: {requests: {storage: 500Mi}}
---
apiVersion: v1
kind: Pod
metadata:
  name: orders-db
  namespace: orders
spec:
  volumes:
    - name: data
      persistentVolumeClaim: {claimName: orders-pvc}
  containers:
    - name: db
      image: busybox:1.36
      command: ["sleep", "3600"]
      volumeMounts:
        - {name: data, mountPath: /data}
```

```bash
k apply -f pv.yaml
k get pv pv-orders                   # Bound  orders/orders-pvc
k -n orders get pvc orders-pvc       # Bound  pv-orders  1Gi
k -n orders get po orders-db         # Running
```

## 함정

- PVC 에 `storageClassName: manual` 을 빠뜨리면 기본 StorageClass(`standard`)가 새 PV 를 동적 프로비저닝해 **다른 PV** 에 Bound 된다. `Bound` 라고 안심하지 말고 `VOLUME` 열이 `pv-orders` 인지 본다.
- PV 와 PVC 의 accessMode 가 다르면 영원히 `Pending`.
- PVC 요청(500Mi)이 PV 용량(1Gi)보다 작아도 Bound 된다. PVC 의 CAPACITY 는 1Gi 로 표시되는 게 정상.
- `Retain` 이므로 PVC 를 지우면 PV 는 `Released` 로 남아 재바인딩되지 않는다. 다시 풀 땐 PV 도 지운다.
