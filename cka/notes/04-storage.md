# 04. Storage (10%)

## 커리큘럼 항목

- StorageClass, 동적 프로비저닝
- 볼륨 타입, accessMode, reclaimPolicy
- PV / PVC 관리

---

## 1. 볼륨 타입 (Pod 레벨)

| 타입 | 수명 | 용도 |
|---|---|---|
| emptyDir | Pod와 동일 | 컨테이너 간 공유, 캐시. `medium: Memory` 가능 |
| hostPath | 노드 | 노드 파일 접근. `type: Directory / DirectoryOrCreate / File` |
| configMap / secret | - | 설정 파일 마운트 |
| persistentVolumeClaim | PV 정책 따름 | 영속 데이터 |
| projected / downwardAPI | - | 토큰, 라벨 등 주입 |
| nfs / csi | 외부 | 네트워크 스토리지 |

```yaml
volumes:
  - name: cache
    emptyDir: {sizeLimit: 500Mi}
  - name: logs
    hostPath: {path: /var/log/app, type: DirectoryOrCreate}
  - name: data
    persistentVolumeClaim: {claimName: data-pvc}
containers:
  - name: app
    volumeMounts:
      - {name: data, mountPath: /data}
      - {name: cache, mountPath: /cache}
      - {name: cfg, mountPath: /etc/app/app.conf, subPath: app.conf}   # 단일 파일
```

## 2. PV / PVC / StorageClass 관계

```
StorageClass ──(동적 프로비저닝)──▶ PV ◀──(바인딩)── PVC ◀──(claimName)── Pod
정적: 관리자가 PV 수동 생성 → PVC가 조건 맞는 PV 찾아 바인딩
```

바인딩 조건: `storageClassName` 일치(둘 다 없거나 같음), `accessModes` PV ⊇ PVC, `capacity` PV ≥ PVC 요청, `volumeMode` 일치, selector(있으면) 일치. 하나라도 어긋나면 PVC `Pending`.

## 3. PV

```yaml
apiVersion: v1
kind: PersistentVolume
metadata: {name: pv-data}
spec:
  capacity: {storage: 5Gi}
  accessModes: [ReadWriteOnce]           # RWO | ROX | RWX | RWOP(ReadWriteOncePod)
  persistentVolumeReclaimPolicy: Retain   # Retain | Delete | Recycle(deprecated)
  storageClassName: manual
  volumeMode: Filesystem                  # Filesystem | Block
  hostPath: {path: /mnt/data}
  # nodeAffinity: hostPath/local 볼륨은 특정 노드 고정 필요할 때
  # local:
  #   path: /mnt/disks/ssd1
  # nodeAffinity:
  #   required:
  #     nodeSelectorTerms:
  #       - matchExpressions: [{key: kubernetes.io/hostname, operator: In, values: [node01]}]
```

accessMode 의미: RWO = 한 노드에서 RW, ROX = 여러 노드 RO, RWX = 여러 노드 RW, RWOP = 한 Pod만 RW.

Reclaim:
- `Retain`: PVC 삭제 시 PV `Released`. 데이터 보존. 재사용하려면 `spec.claimRef` 제거(`k patch pv X -p '{"spec":{"claimRef":null}}'`).
- `Delete`: PV + 실제 스토리지 삭제(동적 프로비저닝 기본).

## 4. PVC

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata: {name: data-pvc, namespace: app}
spec:
  accessModes: [ReadWriteOnce]
  resources: {requests: {storage: 2Gi}}
  storageClassName: manual        # "" 이면 동적 프로비저닝 비활성(정적만)
  volumeMode: Filesystem
  # selector: {matchLabels: {tier: gold}}
```

```bash
k get pv,pvc -A
k describe pvc data-pvc            # Events 에 바인딩 실패 이유
k get pv -o custom-columns=NAME:.metadata.name,CAP:.spec.capacity.storage,MODE:.spec.accessModes,SC:.spec.storageClassName,STATUS:.status.phase,CLAIM:.spec.claimRef.name
```

PVC 확장: StorageClass `allowVolumeExpansion: true` 면 `k edit pvc` 에서 storage 증가. 축소 불가.

## 5. StorageClass

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: fast
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
provisioner: kubernetes.io/no-provisioner      # 정적(local). 동적: ebs.csi.aws.com, rancher.io/local-path 등
reclaimPolicy: Delete
volumeBindingMode: WaitForFirstConsumer        # Immediate | WaitForFirstConsumer
allowVolumeExpansion: true
parameters:
  type: gp3
```

- `WaitForFirstConsumer`: Pod가 스케줄된 뒤 PV 바인딩(로컬/존 제약 있을 때). PVC가 Pod 없이 Pending이면 정상.
- 기본 SC: PVC에 `storageClassName` 생략 시 사용. `k get sc` 에서 `(default)`. 기본 SC 변경 문제 → annotation 토글.
- `kubernetes.io/no-provisioner` = 동적 프로비저닝 안 함. 관리자가 PV 만들어야 함.

```bash
k get sc
k patch sc old -p '{"metadata":{"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'
k patch sc fast -p '{"metadata":{"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
```

## 6. StatefulSet volumeClaimTemplates

```yaml
spec:
  serviceName: db
  volumeClaimTemplates:
    - metadata: {name: data}
      spec:
        accessModes: [ReadWriteOnce]
        storageClassName: fast
        resources: {requests: {storage: 1Gi}}
```

Pod마다 `data-<sts>-<n>` PVC 생성. StatefulSet 삭제해도 PVC 남음.

## 7. 스토리지 트러블슈팅

| 증상 | 원인 | 확인 |
|---|---|---|
| PVC Pending | 맞는 PV 없음 / SC 없음 / 용량·모드 불일치 | `k describe pvc` Events |
| PVC Pending, SC WaitForFirstConsumer | Pod 미생성 정상 | Pod 만들면 바인딩 |
| Pod ContainerCreating | PVC Pending, hostPath 없음, 노드 불일치(RWO 다른 노드) | `k describe po` Events |
| PV Released | PVC 삭제됨, Retain | claimRef 제거 |
| 마운트 권한 오류 | UID 불일치 | `securityContext.fsGroup` |

## 시험 빈출 정리

1. hostPath PV + PVC 생성 → Pod에 마운트 (이름·용량·모드 정확히)
2. PVC Pending 원인 찾아 PV/PVC 수정
3. StorageClass 생성(provisioner, reclaim, bindingMode), 기본 SC 지정
4. PVC 용량 확장
5. Deployment에 PVC 볼륨 추가
6. emptyDir 공유 멀티컨테이너
