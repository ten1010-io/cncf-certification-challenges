# Drills — Storage

준비:
```bash
kubectl create ns drill-s --dry-run=client -o yaml | kubectl apply -f -
for n in cka-control-plane cka-worker cka-worker2; do docker exec $n mkdir -p /mnt/drill; done
```
정리: `kubectl delete ns drill-s; kubectl delete pv --all -l drill=s; kubectl delete sc slow-disk`

---

### S1. PV `pv-drill`(라벨 `drill=s`) 3Gi, RWO, Retain, sc `local-manual`, hostPath `/mnt/drill`. PVC `pvc-drill`(ns drill-s) 1Gi RWO sc `local-manual`. Bound 확인.
<details><summary>정답</summary>

```yaml
apiVersion: v1
kind: PersistentVolume
metadata: {name: pv-drill, labels: {drill: s}}
spec:
  capacity: {storage: 3Gi}
  accessModes: [ReadWriteOnce]
  persistentVolumeReclaimPolicy: Retain
  storageClassName: local-manual
  hostPath: {path: /mnt/drill}
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata: {name: pvc-drill, namespace: drill-s}
spec:
  accessModes: [ReadWriteOnce]
  storageClassName: local-manual
  resources: {requests: {storage: 1Gi}}
```
PVC 1Gi 요청 → PV 3Gi 에 바인딩되고 PVC capacity 는 3Gi 로 표시됨(정상).
</details>

### S2. Deployment `writer`(busybox, `while true; do date >> /data/t.log; sleep 2; done`) 에 `pvc-drill` 을 `/data` 로 마운트. 파일이 쌓이는지 exec 로 확인.
<details><summary>정답</summary>

```yaml
volumes:
  - name: data
    persistentVolumeClaim: {claimName: pvc-drill}
containers:
  - volumeMounts: [{name: data, mountPath: /data}]
```
```bash
k -n drill-s exec deploy/writer -- tail -3 /data/t.log
```
</details>

### S3. StorageClass `slow-disk`: provisioner `kubernetes.io/no-provisioner`, Immediate, Delete, allowVolumeExpansion true.
<details><summary>정답</summary>

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata: {name: slow-disk}
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: Immediate
reclaimPolicy: Delete
allowVolumeExpansion: true
```
</details>

### S4. 기본 StorageClass 를 `slow-disk` 로 바꾸고 `standard` 는 해제. `k get sc` 에 `(default)` 하나만.
<details><summary>정답</summary>

```bash
k patch sc standard -p '{"metadata":{"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'
k patch sc slow-disk -p '{"metadata":{"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
```
</details>

### S5. PVC `bad-pvc` 가 Pending: `accessModes: [ReadWriteMany]`, sc `local-manual`, 5Gi. 클러스터에는 RWO 3Gi PV 만 있음. 원인 2개를 말하고, PV 는 두고 PVC 만 고쳐 Bound 시키기 (PV `pv-drill` 이 Available 이어야 함 — S2 의 writer/pvc 삭제 후).
<details><summary>정답</summary>

원인: accessMode RWX ⊄ PV RWO, 요청 5Gi > 3Gi.
accessModes/용량은 불변 → PVC 삭제 후 재생성(RWO, ≤3Gi). Retain PV 가 Released 면 `k patch pv pv-drill -p '{"spec":{"claimRef":null}}'` 로 Available 복귀.
</details>

### S6. Pod `cache`: 컨테이너 2개가 `emptyDir`(메모리 기반, 64Mi 제한) 을 `/cache` 로 공유.
<details><summary>정답</summary>

```yaml
volumes:
  - name: cache
    emptyDir: {medium: Memory, sizeLimit: 64Mi}
```
</details>

### S7. `pvc-drill` 을 2Gi 로 확장 시도. 왜 안 되는지 설명.
<details><summary>정답</summary>

`k -n drill-s edit pvc pvc-drill` → storage 2Gi. sc `local-manual` 은 실제 SC 오브젝트가 없거나 `allowVolumeExpansion` 없음 → 거부. 확장은 SC 에 `allowVolumeExpansion: true` + CSI 지원 필요. hostPath 는 확장 불가.
</details>

### S8. Pod 가 hostPath `/var/log` 를 읽기 전용으로 `/host-logs` 에 마운트.
<details><summary>정답</summary>

```yaml
volumes:
  - name: hl
    hostPath: {path: /var/log, type: Directory}
containers:
  - volumeMounts: [{name: hl, mountPath: /host-logs, readOnly: true}]
```
</details>
