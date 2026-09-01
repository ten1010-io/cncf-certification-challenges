#!/usr/bin/env python3
"""README 에서 <!--info-header-*--> / <!--info-footer-*--> 블록(같은 줄이든 여러 줄이든)을 제거해 본문만 출력."""
import re, sys
s = open(sys.argv[1], encoding="utf-8").read()
s = re.sub(r"<!--info-header-start-->.*?<!--info-header-end-->", "", s, flags=re.S)
s = re.sub(r"<!--info-footer-start-->.*?<!--info-footer-end-->", "", s, flags=re.S)
if len(sys.argv) > 2 and sys.argv[2] == "--no-run":   # '## 실행' 이후 제거 (모의고사 문제지용)
    s = re.split(r"^## 실행\s*$", s, flags=re.M)[0]
print(s.strip())
