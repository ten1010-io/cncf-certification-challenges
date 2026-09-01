#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0023
q_start 0023 4 "Job 과 CronJob 생성"
expect_eq "countdown completions 3" "3" "$(jp jobs job/countdown '{.spec.completions}')"
expect_eq "countdown parallelism 1" "1" "$(jp jobs job/countdown '{.spec.parallelism}')"
expect_eq "countdown backoffLimit 2" "2" "$(jp jobs job/countdown '{.spec.backoffLimit}')"
expect_eq "countdown 이미지 busybox:1.36" "busybox:1.36" "$(jp jobs job/countdown '{.spec.template.spec.containers[0].image}')"
expect_eq "countdown succeeded 3" "3" "$(jp jobs job/countdown '{.status.succeeded}')"
expect_eq "cleanup schedule */5 * * * *" "*/5 * * * *" "$(jp jobs cronjob/cleanup '{.spec.schedule}')"
expect_eq "cleanup 이미지 busybox:1.36" "busybox:1.36" "$(jp jobs cronjob/cleanup '{.spec.jobTemplate.spec.template.spec.containers[0].image}')"
expect_eq "cleanup concurrencyPolicy Forbid" "Forbid" "$(jp jobs cronjob/cleanup '{.spec.concurrencyPolicy}')"
expect_eq "cleanup successfulJobsHistoryLimit 2" "2" "$(jp jobs cronjob/cleanup '{.spec.successfulJobsHistoryLimit}')"
q_end; report
