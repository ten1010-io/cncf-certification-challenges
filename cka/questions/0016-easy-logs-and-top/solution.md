# 풀이 — 0016 로그와 리소스 모니터링

```bash
k get po crasher                              # CrashLoopBackOff
k logs crasher                                # 현재(재시작된) 컨테이너 로그. 없으면 --previous
k logs crasher --previous | grep FATAL > /tmp/cncf-out/crasher.log
cat /tmp/cncf-out/crasher.log                 # FATAL: config file /etc/app/config.yaml not found

k top po -n load --sort-by=cpu
k top po -n load --sort-by=cpu --no-headers | head -1 | awk '{print $1}' > /tmp/cncf-out/top-cpu.txt
cat /tmp/cncf-out/top-cpu.txt                 # busy
```

`Metrics API not available` 이면 metrics-server 확인: `k -n kube-system get deploy metrics-server`. 배포 직후에는 수집까지 1분 정도 걸린다.

## 함정

- 파일에 **이름만** 들어가야 한다. `k top po` 출력 줄을 그대로 저장하면(`busy 180m 0Mi`) 0점.
- `--previous` 는 재시작 전 컨테이너 로그. CrashLoopBackOff 라도 현재 컨테이너가 이미 죽어 있으면 `--previous` 없이도 같은 내용이 보이지만, 확실히 하려면 `--previous`.
- `k top` 은 `--sort-by=cpu` 를 지원한다. `--no-headers` 로 헤더 제거.
