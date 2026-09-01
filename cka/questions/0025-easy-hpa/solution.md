# 풀이 — 0025 HPA 생성

```bash
k -n autoscale autoscale deploy hpa-web --name=hpa-web --min=2 --max=6 --cpu-percent=60
k -n autoscale get hpa hpa-web
k -n autoscale describe hpa hpa-web     # Metrics: cpu 사용률 확인 (metrics-server 필요)
```

YAML 로 쓰면 (autoscaling/v2):

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata: {name: hpa-web, namespace: autoscale}
spec:
  scaleTargetRef: {apiVersion: apps/v1, kind: Deployment, name: hpa-web}
  minReplicas: 2
  maxReplicas: 6
  metrics:
    - type: Resource
      resource:
        name: cpu
        target: {type: Utilization, averageUtilization: 60}
```

## 함정

- `k autoscale` 에 `--name` 을 빼면 HPA 이름이 Deployment 이름과 같아져 이 문제는 우연히 맞지만, 이름이 다른 문제에서는 0점.
- 목표 CPU "사용률(%)" 은 `averageUtilization` 이다. `averageValue: 60m` 같은 절대값으로 쓰면 다른 의미.
- HPA 가 `<unknown>` 을 보이면 Deployment 에 `resources.requests.cpu` 가 없거나 metrics-server 가 없는 경우. 채점은 spec 기준이지만 실제 시험에서는 `k describe hpa` 로 동작 확인까지 한다.
