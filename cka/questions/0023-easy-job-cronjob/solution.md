# 풀이 — 0023 Job 과 CronJob 생성

```bash
k -n jobs create job countdown --image=busybox:1.36 --dry-run=client -o yaml \
  -- sh -c 'for i in 5 4 3 2 1; do echo $i; sleep 1; done' > job.yaml
# spec 에 completions: 3, parallelism: 1, backoffLimit: 2 추가
k apply -f job.yaml
k -n jobs get job countdown -w                            # COMPLETIONS 3/3 (약 20초)

k -n jobs create cronjob cleanup --image=busybox:1.36 --schedule="*/5 * * * *" --dry-run=client -o yaml \
  -- echo cleanup > cj.yaml
# spec 에 concurrencyPolicy: Forbid, successfulJobsHistoryLimit: 2 추가
k apply -f cj.yaml
```

```yaml
apiVersion: batch/v1
kind: Job
metadata: {name: countdown, namespace: jobs}
spec:
  completions: 3
  parallelism: 1
  backoffLimit: 2
  template:
    spec:
      restartPolicy: Never
      containers:
        - name: countdown
          image: busybox:1.36
          command: ["sh", "-c", "for i in 5 4 3 2 1; do echo $i; sleep 1; done"]
---
apiVersion: batch/v1
kind: CronJob
metadata: {name: cleanup, namespace: jobs}
spec:
  schedule: "*/5 * * * *"
  concurrencyPolicy: Forbid
  successfulJobsHistoryLimit: 2
  jobTemplate:
    spec:
      template:
        spec:
          restartPolicy: OnFailure
          containers:
            - name: cleanup
              image: busybox:1.36
              command: ["echo", "cleanup"]
```

## 함정

- `completions/parallelism/backoffLimit` 은 **Job.spec**, `concurrencyPolicy/successfulJobsHistoryLimit` 은 **CronJob.spec** (jobTemplate 안이 아니다). 위치를 틀리면 `unknown field` 로 거부되거나 무시된다.
- 셸에서 `$i` 가 확장되지 않게 `'...'` 로 감싼다. `"..."` 를 쓰면 빈 문자열이 들어가 echo 만 세 번 찍힌다.
- Job 의 `restartPolicy` 는 `Never` 또는 `OnFailure` 만 가능. `create job` 이 자동으로 `Never` 를 넣어준다.
- Job 은 수정 불가 필드가 많다. 잘못 만들었으면 삭제 후 재생성.
