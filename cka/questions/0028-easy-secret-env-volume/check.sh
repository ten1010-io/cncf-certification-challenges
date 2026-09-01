#!/usr/bin/env bash
set -uo pipefail
source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"
q_init 0028
q_start 0028 5 "Secret 환경변수·볼륨 주입"
expect "Secret db-creds 존재" $K -n secure-app get secret db-creds
expect_eq "secret username=admin" "admin" "$(jp secure-app secret/db-creds '{.data.username}' | base64 -d 2>/dev/null)"
expect_eq "secret password=s3cr3t" "s3cr3t" "$(jp secure-app secret/db-creds '{.data.password}' | base64 -d 2>/dev/null)"
expect_eq "Pod secure-app Running" "Running" "$(jp secure-app pod/secure-app '{.status.phase}')"
expect_eq "env DB_USER ← db-creds/username" "db-creds/username" "$(jp secure-app pod/secure-app '{.spec.containers[0].env[?(@.name=="DB_USER")].valueFrom.secretKeyRef.name}/{.spec.containers[0].env[?(@.name=="DB_USER")].valueFrom.secretKeyRef.key}')"
expect_eq "컨테이너 안 DB_USER=admin (기능)" "admin" "$($K -n secure-app exec secure-app -- sh -c 'echo -n $DB_USER' 2>/dev/null)"
expect_eq "/etc/creds/password 내용 (기능)" "s3cr3t" "$($K -n secure-app exec secure-app -- cat /etc/creds/password 2>/dev/null)"
RO=$(jp secure-app pod/secure-app '{.spec.containers[0].volumeMounts[?(@.mountPath=="/etc/creds")].readOnly}')
expect_eq "/etc/creds readOnly 마운트" "true" "$RO"
q_end; report
