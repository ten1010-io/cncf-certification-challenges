# 풀이 — 0001 RBAC ServiceAccount 권한 부여

```bash
k -n ci create sa deploy-bot
k -n ci create role deploy-manager --verb=get,list,create,update,delete --resource=deployments
k -n ci edit role deploy-manager     # pods 는 verb 가 다르므로 rule 하나 더 추가
```

```yaml
rules:
- apiGroups: ["apps"]
  resources: ["deployments"]
  verbs: ["get","list","create","update","delete"]
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get","list"]
```

```bash
k -n ci create rolebinding deploy-bot-rb --role=deploy-manager --serviceaccount=ci:deploy-bot
k auth can-i create deployments --as=system:serviceaccount:ci:deploy-bot -n ci   # yes
k auth can-i delete pods --as=system:serviceaccount:ci:deploy-bot -n ci          # no
```

## 함정

- `deployments` 의 apiGroup 은 `apps`. `k create role` 은 자동 처리하지만 YAML 직접 쓸 때 `""` 로 두면 권한이 안 먹는다.
- `k create role` 에 `--verb` 와 `--resource` 를 섞어 여러 개 주면 모든 verb × 모든 resource 로 합쳐진다. verb 가 다른 리소스는 rule 을 분리.
- ClusterRoleBinding 을 쓰면 "ci 밖에서 권한 없음" 조건 위반.
