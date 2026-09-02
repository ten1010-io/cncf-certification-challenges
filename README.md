<!-- 이 파일은 scripts/gen-readme.sh 가 생성한다. 직접 수정하지 말고 scripts/templates/ 와 각 문제의 info.yml 을 수정. -->
<h1 align="center">CNCF Certification Challenges</h1>

<p align="center">
CKA · CKAD · CKS 실습형 문제 은행. 브라우저(Codespaces) 안 실제 Kubernetes 클러스터에서 풀고, 자동 채점하고, Issue 로 풀이를 공유한다.<br>
<sub>Hands-on Kubernetes certification challenges with auto-grading. Structure inspired by <a href="https://github.com/type-challenges/type-challenges">type-challenges</a>.</sub>
</p>

<p align="center">
<a href="https://codespaces.new/ten1010-io/cncf-certification-challenges?quickstart=1"><img src="https://img.shields.io/badge/-Open%20in%20Codespaces-24292f?logo=github&style=for-the-badge" alt="Open in Codespaces"/></a>
<a href="https://github.com/ten1010-io/cncf-certification-challenges/issues?q=label%3Aanswer"><img src="https://img.shields.io/badge/-Solutions-de5a77?style=for-the-badge" alt="Solutions"/></a>
<a href="https://github.com/ten1010-io/cncf-certification-challenges/issues/new?template=new-question.yml"><img src="https://img.shields.io/badge/-Add%20a%20Question-teal?style=for-the-badge" alt="Add a Question"/></a>
</p>

## 사용법

Codespaces 는 열리면 클러스터를 백그라운드로 자동 생성한다(첫 3~5분). 터미널에서:

```bash
q start 13          # 환경 구성 + 지문 출력. 이제 kubectl 로 풀기
q check             # 채점 (마지막 start 한 문제)
q solution          # 풀이 (스포일러)
q list cka          # 목록 (--domain troubleshooting --difficulty hard 필터)

q exam start exam-01   # 모의고사 17문항 2시간. 문제지 /tmp/cncf-out/cka-exam-01-questions.md
q exam check exam-01   # 합산 채점, 합격 판정
```

로컬(Docker + kind + kubectl)에서는 `./bin/q cluster up` 먼저.

풀고 나서 각 문제의 **Share your Solution** 버튼 → Issue 에 명령·YAML·`q check` 출력 붙이기. 다른 사람 풀이는 **Check out Solutions**.
새 문제는 **Add a Question** 이슈 폼 → 봇이 PR 생성 → 메인테이너 `approved` 라벨 → 자동 머지.

난이도: <img src="https://img.shields.io/badge/-easy-7aad0c"/> <img src="https://img.shields.io/badge/-medium-d9901a"/> <img src="https://img.shields.io/badge/-hard-de3d37"/>

## CKA — Certified Kubernetes Administrator

노트: [`cka/notes/`](cka/notes/) · 모의고사: [exam-01](cka/exams/exam-01.yml) [exam-02](cka/exams/exam-02.yml) 

### Troubleshooting

<a href="./cka/questions/0003-medium-broken-deployment-catalog/README.md"><img src="https://img.shields.io/badge/0003-%EA%B3%A0%EC%9E%A5%EB%82%9C%20Deployment%20%EC%88%98%EC%A0%95-d9901a" alt="0003 고장난 Deployment 수정"/></a> <a href="./cka/questions/0014-medium-node-notready-kubelet-stopped/README.md"><img src="https://img.shields.io/badge/0014-%EB%85%B8%EB%93%9C%20NotReady%20%EB%B3%B5%EA%B5%AC%20%28kubelet%20%EC%A0%95%EC%A7%80%29-d9901a" alt="0014 노드 NotReady 복구 (kubelet 정지)"/></a> <a href="./cka/questions/0015-hard-coredns-corefile-broken/README.md"><img src="https://img.shields.io/badge/0015-CoreDNS%20Corefile%20%EB%B3%B5%EA%B5%AC%20%28DNS%20%EC%9E%A5%EC%95%A0%29-de3d37" alt="0015 CoreDNS Corefile 복구 (DNS 장애)"/></a> <a href="./cka/questions/0016-easy-logs-and-top/README.md"><img src="https://img.shields.io/badge/0016-%EB%A1%9C%EA%B7%B8%EC%99%80%20%EB%A6%AC%EC%86%8C%EC%8A%A4%20%EB%AA%A8%EB%8B%88%ED%84%B0%EB%A7%81-7aad0c" alt="0016 로그와 리소스 모니터링"/></a> <a href="./cka/questions/0017-medium-service-endpoints-mismatch/README.md"><img src="https://img.shields.io/badge/0017-Service%20%EC%97%B0%EA%B2%B0%20%EB%B6%88%EA%B0%80%20%28selector%2C%20targetPort%20%EB%B6%88%EC%9D%BC%EC%B9%98%29-d9901a" alt="0017 Service 연결 불가 (selector, targetPort 불일치)"/></a> <a href="./cka/questions/0018-hard-kube-scheduler-manifest-broken/README.md"><img src="https://img.shields.io/badge/0018-%EC%BB%A8%ED%8A%B8%EB%A1%A4%ED%94%8C%EB%A0%88%EC%9D%B8%20%EC%9E%A5%EC%95%A0%20%28kube--scheduler%20%EB%A7%A4%EB%8B%88%ED%8E%98%EC%8A%A4%ED%8A%B8%29-de3d37" alt="0018 컨트롤플레인 장애 (kube-scheduler 매니페스트)"/></a> <a href="./cka/questions/0019-hard-node-notready-kubelet-config/README.md"><img src="https://img.shields.io/badge/0019-%EB%85%B8%EB%93%9C%20NotReady%20%EB%B3%B5%EA%B5%AC%20%28kubelet%20kubeconfig%20%ED%8F%AC%ED%8A%B8%20%EC%98%A4%EB%A5%98%29-de3d37" alt="0019 노드 NotReady 복구 (kubelet kubeconfig 포트 오류)"/></a> <a href="./cka/questions/0024-medium-pending-pod-resources-nodeselector/README.md"><img src="https://img.shields.io/badge/0024-Pending%20Pod%20%ED%95%B4%EA%B2%B0%20%28%EB%A6%AC%EC%86%8C%EC%8A%A4%20%EC%9A%94%EA%B5%AC%20%2B%20nodeSelector%29-d9901a" alt="0024 Pending Pod 해결 (리소스 요구 + nodeSelector)"/></a> <a href="./cka/questions/0032-hard-crashloopbackoff-configmap-probe/README.md"><img src="https://img.shields.io/badge/0032-CrashLoopBackOff%20%EB%B3%B5%EA%B5%AC%20%28ConfigMap%20%ED%82%A4%20%2B%20liveness%29-de3d37" alt="0032 CrashLoopBackOff 복구 (ConfigMap 키 + liveness)"/></a> <a href="./cka/questions/0034-easy-jsonpath-extraction/README.md"><img src="https://img.shields.io/badge/0034-jsonpath%20/%20sort--by%20%EC%A0%95%EB%B3%B4%20%EC%B6%94%EC%B6%9C-7aad0c" alt="0034 jsonpath / sort-by 정보 추출"/></a> 

### Cluster Architecture, Installation & Configuration

<a href="./cka/questions/0001-easy-rbac-deploy-bot/README.md"><img src="https://img.shields.io/badge/0001-RBAC%20ServiceAccount%20%EA%B6%8C%ED%95%9C%20%EB%B6%80%EC%97%AC-7aad0c" alt="0001 RBAC ServiceAccount 권한 부여"/></a> <a href="./cka/questions/0013-medium-etcd-snapshot/README.md"><img src="https://img.shields.io/badge/0013-etcd%20%EC%8A%A4%EB%83%85%EC%83%B7%20%EB%B0%B1%EC%97%85-d9901a" alt="0013 etcd 스냅샷 백업"/></a> <a href="./cka/questions/0020-medium-helm-install-upgrade/README.md"><img src="https://img.shields.io/badge/0020-Helm%20%EC%84%A4%EC%B9%98%EC%99%80%20%EC%97%85%EA%B7%B8%EB%A0%88%EC%9D%B4%EB%93%9C-d9901a" alt="0020 Helm 설치와 업그레이드"/></a> <a href="./cka/questions/0021-medium-kustomize-overlay/README.md"><img src="https://img.shields.io/badge/0021-Kustomize%20overlay%20%EC%9E%91%EC%84%B1%EA%B3%BC%20%EC%A0%81%EC%9A%A9-d9901a" alt="0021 Kustomize overlay 작성과 적용"/></a> <a href="./cka/questions/0022-easy-crd-custom-resource/README.md"><img src="https://img.shields.io/badge/0022-CRD%20%EC%A1%B0%ED%9A%8C%EC%99%80%20Custom%20Resource%20%EC%83%9D%EC%84%B1-7aad0c" alt="0022 CRD 조회와 Custom Resource 생성"/></a> <a href="./cka/questions/0030-medium-etcd-restore-plan/README.md"><img src="https://img.shields.io/badge/0030-etcd%20%EC%8A%A4%EB%83%85%EC%83%B7%20%2B%20%EB%B3%B5%EC%9B%90%20%EC%A0%88%EC%B0%A8%20%EC%9E%91%EC%84%B1-d9901a" alt="0030 etcd 스냅샷 + 복원 절차 작성"/></a> <a href="./cka/questions/0031-medium-kubeadm-upgrade-plan/README.md"><img src="https://img.shields.io/badge/0031-kubeadm%20control--plane%20%EC%97%85%EA%B7%B8%EB%A0%88%EC%9D%B4%EB%93%9C%20%EC%A0%88%EC%B0%A8%20%EC%9E%91%EC%84%B1-d9901a" alt="0031 kubeadm control-plane 업그레이드 절차 작성"/></a> <a href="./cka/questions/0033-easy-node-drain-maintenance/README.md"><img src="https://img.shields.io/badge/0033-%EB%85%B8%EB%93%9C%20%EC%9C%A0%EC%A7%80%EB%B3%B4%EC%88%98%20%28drain%29-7aad0c" alt="0033 노드 유지보수 (drain)"/></a> 

### Services & Networking

<a href="./cka/questions/0010-medium-networkpolicy-allow-frontend/README.md"><img src="https://img.shields.io/badge/0010-NetworkPolicy%20%E2%80%94%20frontend%20%EB%A7%8C%20%ED%97%88%EC%9A%A9-d9901a" alt="0010 NetworkPolicy — frontend 만 허용"/></a> <a href="./cka/questions/0011-easy-ingress-shop/README.md"><img src="https://img.shields.io/badge/0011-Ingress%20%EA%B2%BD%EB%A1%9C%20%EB%9D%BC%EC%9A%B0%ED%8C%85-7aad0c" alt="0011 Ingress 경로 라우팅"/></a> <a href="./cka/questions/0012-medium-gateway-api-shop/README.md"><img src="https://img.shields.io/badge/0012-Gateway%20API%20%E2%80%94%20Gateway%20%2B%20HTTPRoute-d9901a" alt="0012 Gateway API — Gateway + HTTPRoute"/></a> <a href="./cka/questions/0026-medium-networkpolicy-default-deny-dns/README.md"><img src="https://img.shields.io/badge/0026-NetworkPolicy%20default--deny%20%2B%20DNS%20%ED%97%88%EC%9A%A9-d9901a" alt="0026 NetworkPolicy default-deny + DNS 허용"/></a> <a href="./cka/questions/0027-medium-ingress-to-gateway-migration/README.md"><img src="https://img.shields.io/badge/0027-Ingress%20%E2%86%92%20Gateway%20API%20%EB%A7%88%EC%9D%B4%EA%B7%B8%EB%A0%88%EC%9D%B4%EC%85%98-d9901a" alt="0027 Ingress → Gateway API 마이그레이션"/></a> 

### Workloads & Scheduling

<a href="./cka/questions/0002-easy-deployment-nodeport/README.md"><img src="https://img.shields.io/badge/0002-Deployment%20%2B%20NodePort%20Service-7aad0c" alt="0002 Deployment + NodePort Service"/></a> <a href="./cka/questions/0004-easy-rollout-rollback/README.md"><img src="https://img.shields.io/badge/0004-%EB%A1%A4%EB%A7%81%20%EC%97%85%EB%8D%B0%EC%9D%B4%ED%8A%B8%EC%99%80%20%EB%A1%A4%EB%B0%B1-7aad0c" alt="0004 롤링 업데이트와 롤백"/></a> <a href="./cka/questions/0005-medium-taint-toleration-scheduling/README.md"><img src="https://img.shields.io/badge/0005-taint/toleration%20%2B%20nodeSelector%20%EC%8A%A4%EC%BC%80%EC%A4%84%EB%A7%81-d9901a" alt="0005 taint/toleration + nodeSelector 스케줄링"/></a> <a href="./cka/questions/0006-easy-daemonset-all-nodes/README.md"><img src="https://img.shields.io/badge/0006-DaemonSet%20%EC%A0%84%20%EB%85%B8%EB%93%9C%20%EB%B0%B0%EC%B9%98-7aad0c" alt="0006 DaemonSet 전 노드 배치"/></a> <a href="./cka/questions/0007-easy-sidecar-logging/README.md"><img src="https://img.shields.io/badge/0007-%EC%82%AC%EC%9D%B4%EB%93%9C%EC%B9%B4%20%EB%A1%9C%EA%B9%85%20%28emptyDir%20%EA%B3%B5%EC%9C%A0%29-7aad0c" alt="0007 사이드카 로깅 (emptyDir 공유)"/></a> <a href="./cka/questions/0023-easy-job-cronjob/README.md"><img src="https://img.shields.io/badge/0023-Job%20%EA%B3%BC%20CronJob%20%EC%83%9D%EC%84%B1-7aad0c" alt="0023 Job 과 CronJob 생성"/></a> <a href="./cka/questions/0025-easy-hpa/README.md"><img src="https://img.shields.io/badge/0025-HPA%20%EC%83%9D%EC%84%B1-7aad0c" alt="0025 HPA 생성"/></a> <a href="./cka/questions/0028-easy-secret-env-volume/README.md"><img src="https://img.shields.io/badge/0028-Secret%20%ED%99%98%EA%B2%BD%EB%B3%80%EC%88%98%C2%B7%EB%B3%BC%EB%A5%A8%20%EC%A3%BC%EC%9E%85-7aad0c" alt="0028 Secret 환경변수·볼륨 주입"/></a> 

### Storage

<a href="./cka/questions/0008-medium-pv-pvc-hostpath/README.md"><img src="https://img.shields.io/badge/0008-PV%20/%20PVC%20%28hostPath%2C%20manual%29-d9901a" alt="0008 PV / PVC (hostPath, manual)"/></a> <a href="./cka/questions/0009-easy-default-storageclass/README.md"><img src="https://img.shields.io/badge/0009-%EA%B8%B0%EB%B3%B8%20StorageClass%20%EB%B3%80%EA%B2%BD-7aad0c" alt="0009 기본 StorageClass 변경"/></a> <a href="./cka/questions/0029-medium-pvc-accessmode-mismatch/README.md"><img src="https://img.shields.io/badge/0029-PVC%20Pending%20%28accessModes%20%EB%B6%88%EC%9D%BC%EC%B9%98%29-d9901a" alt="0029 PVC Pending (accessModes 불일치)"/></a> 

## 공통 자료

- [시험 환경·전략](common/exam-environment.md) — PSI 환경, 시간 배분, 문서 북마크, 실수 체크리스트
- [kubectl 치트시트](common/kubectl-cheatsheet.md)
- [클러스터 스크립트](common/setup/) — kind 3노드 + Calico + metrics-server + ingress-nginx + Gateway API

## 실제 시험과의 차이

| 실제 시험 | 여기 |
|---|---|
| 문제마다 다른 클러스터 | 단일 kind 클러스터. `q exam` 은 문항 환경을 한 번에 구성 |
| `ssh node01` | `docker exec -it cka-worker bash` |
| 결과 파일 `/opt/...` | `/tmp/cncf-out/...` |
| kubeadm 업그레이드·etcd 복원 실습 | kind 에서 위험 → 명령 시퀀스 작성형 문제로 대체 |

## 로컬 실행 (크레딧 없이 무제한)

Codespaces 와 동일한 kind 클러스터를 로컬 Docker 에 만든다. minikube 는 노드명·인증서 경로·포트가 달라 일부 문제와 어긋나므로 kind 권장.

```bash
brew install kind kubectl helm            # Docker Desktop: Memory 8GB, CPU 4 이상
git clone https://github.com/ten1010-io/cncf-certification-challenges.git && cd $(basename ten1010-io/cncf-certification-challenges)
export PATH="$PATH:$PWD/bin"; alias k=kubectl
q cluster up                              # 첫 5분
q start 1
```

문제별 환경은 `<cert>/questions/NNNN-*/setup.sh`, 채점 기준은 같은 폴더 `check.sh`, 클러스터 구성은 `common/setup/`.

## Codespaces 속도

첫 생성은 이미지 빌드(docker-in-docker + kubectl/kind/helm) 2~4분 + `q cluster up` 3~5분. 팀 저장소면 **Settings → Codespaces → Set up prebuild** (branch `main`, region 가까운 곳) 를 켜두면 빌드 단계가 사라져 수십 초에 열린다. Codespace 는 정지해도 디스크가 남으므로 두 번째부터는 클러스터도 대개 살아 있다.

## 기여

풀이 공유 = Issue, 문제 추가 = **Add a Question** 이슈 폼(봇이 PR 생성, `approved` 라벨로 머지) 또는 직접 PR. 규약은 [CONTRIBUTING.md](CONTRIBUTING.md).

## License

[MIT](LICENSE)
