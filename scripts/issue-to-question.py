#!/usr/bin/env python3
"""'새 문제 제안' 이슈 폼 본문을 파싱해 문제 폴더를 생성한다.

사용: issue-to-question.py <event.json | issue-body.md> [--root DIR] [--dry-run]
  - event.json (GitHub Actions 의 $GITHUB_EVENT_PATH) 또는 이슈 본문 파일
  - 성공: 폴더 생성, stdout 에 'id=NNNN', 'dir=<path>', 'title=...' 출력
  - 실패: stderr 에 오류 목록, exit 1
"""
import json, os, re, stat, sys
from pathlib import Path

FIELDS = {  # 폼 label → key
    "자격증": "cert", "도메인": "domain", "난이도": "difficulty", "제목": "title", "slug": "slug",
    "배점": "points", "태그": "tags", "노드 접근 필요 (docker exec)": "node_access",
    "다른 문항 환경을 깨뜨리는가 (스케줄러·kubelet·DNS 정지 등)": "disruptive",
    "지문": "question", "setup.sh 본문": "setup", "check.sh 본문": "check", "cleanup.sh 본문": "cleanup", "풀이": "solution",
}
DOMAINS = {
    "cka": ["troubleshooting", "cluster", "networking", "workloads", "storage"],
    "ckad": ["environment", "design", "deployment", "networking", "observability"],
    "cks": ["cluster-setup", "hardening", "system-hardening", "microservice", "supply-chain", "monitoring"],
}
LIB = 'source "$(cd "$(dirname "$0")" && pwd)/../../../common/setup/lib.sh"'


def parse_body(body: str) -> dict:
    parts = re.split(r"^### (.+?)\s*$", body.replace("\r\n", "\n"), flags=re.M)
    out = {}
    for i in range(1, len(parts) - 1, 2):
        label, val = parts[i].strip(), parts[i + 1].strip()
        if val == "_No response_":
            val = ""
        m = re.match(r"^```[a-z]*\n(.*?)\n?```$", val, flags=re.S)  # render: bash 필드
        if m:
            val = m.group(1)
        key = FIELDS.get(label)
        if key:
            out[key] = val.strip("\n")
    return out


def next_id(root: Path) -> int:
    ids = [int(p.name[:4]) for p in root.glob("*/questions/[0-9][0-9][0-9][0-9]-*") if p.is_dir()]
    return max(ids, default=0) + 1


def validate(f: dict) -> list:
    errs = []
    for k in ("cert", "domain", "difficulty", "title", "slug", "points", "question", "setup", "check", "cleanup", "solution"):
        if not f.get(k):
            errs.append(f"필수 항목 비어있음: {k}")
    if f.get("cert") and f["cert"] not in DOMAINS:
        errs.append(f"자격증 값 오류: {f['cert']}")
    if f.get("cert") in DOMAINS and f.get("domain") and f["domain"] not in DOMAINS[f["cert"]]:
        errs.append(f"도메인 '{f['domain']}' 은 {f['cert']} 에 없음. 허용: {', '.join(DOMAINS[f['cert']])}")
    if f.get("difficulty") not in ("easy", "medium", "hard"):
        errs.append("난이도는 easy|medium|hard")
    if f.get("slug") and not re.fullmatch(r"[a-z0-9]+(-[a-z0-9]+)*", f["slug"]):
        errs.append("slug 는 영문 소문자·숫자·하이픈만 (예: node-notready-kubelet-stopped)")
    if f.get("points") and not re.fullmatch(r"[1-9][0-9]?", f["points"]):
        errs.append("배점은 1~99 정수")
    if f.get("check") and not re.search(r"^\s*expect", f["check"], flags=re.M):
        errs.append("check.sh 본문에 expect* 호출이 최소 1개 필요")
    for k in ("setup", "check", "cleanup"):
        if f.get(k) and re.search(r"^\s*(#!/|source .*lib\.sh|q_init|q_start|q_end)", f[k], flags=re.M):
            errs.append(f"{k}.sh 본문에는 헤더(#!, source, q_init, q_start, q_end)를 넣지 않는다. 봇이 붙인다")
    return errs


def render(f: dict, qid: int) -> dict:
    id4 = f"{qid:04d}"
    tags = [t.strip() for t in re.split(r"[,\s]+", f.get("tags", "")) if t.strip()]
    disruptive = f.get("disruptive", "false") == "true"
    hdr = f"#!/usr/bin/env bash\nset -euo pipefail\n{LIB}\nq_init {id4}\n"
    hdr_soft = f"#!/usr/bin/env bash\nset -uo pipefail\n{LIB}\nq_init {id4}\n"
    title_sh = f["title"].replace('"', '\\"')
    return {
        "info.yml": (
            f"id: {qid}\ntitle: {f['title']}\ndifficulty: {f['difficulty']}\ncert: {f['cert']}\ndomain: {f['domain']}\n"
            f"points: {f['points']}\ntags: [{', '.join(tags)}]\ndisruptive: {'true' if disruptive else 'false'}\n"
            f"setup_order: {10 if disruptive else 0}\nnode_access: {f.get('node_access', 'false')}\n"
        ),
        "README.md": (
            "<!--info-header-start--><!--info-header-end-->\n\n## 문제\n\n" + f["question"].strip() + "\n\n## 실행\n\n```bash\n"
            f"q start {qid}      # 환경 구성 + 지문 출력\nq check         # 채점\n```\n\n"
            "로컬(Codespaces 아님)이면 `./bin/q`. 풀이는 `q solution`, 환경 초기화는 `q reset`.\n\n"
            "<!--info-footer-start--><!--info-footer-end-->\n"
        ),
        "setup.sh": hdr + f["setup"].strip() + "\n",
        "check.sh": hdr_soft + f'q_start {id4} {f["points"]} "{title_sh}"\n' + f["check"].strip() + "\nq_end; report\n",
        "cleanup.sh": hdr_soft + f["cleanup"].strip() + "\n",
        "solution.md": f"# 풀이 — {id4} {f['title']}\n\n" + f["solution"].strip() + "\n",
    }


def main():
    args = sys.argv[1:]
    root = Path(args[args.index("--root") + 1]) if "--root" in args else Path(__file__).resolve().parent.parent
    dry = "--dry-run" in args
    src = Path(args[0])
    raw = src.read_text(encoding="utf-8")
    body = json.loads(raw)["issue"]["body"] if src.suffix == ".json" else raw
    f = parse_body(body)
    errs = validate(f)
    if errs:
        print("\n".join("- " + e for e in errs), file=sys.stderr)
        sys.exit(1)
    qid = next_id(root)
    d = root / f["cert"] / "questions" / f"{qid:04d}-{f['difficulty']}-{f['slug']}"
    files = render(f, qid)
    if not dry:
        d.mkdir(parents=True, exist_ok=False)
        for name, content in files.items():
            p = d / name
            p.write_text(content, encoding="utf-8")
            if name.endswith(".sh"):
                p.chmod(p.stat().st_mode | stat.S_IXUSR | stat.S_IXGRP | stat.S_IXOTH)
    print(f"id={qid:04d}\ndir={d.relative_to(root)}\ntitle={f['title']}\ncert={f['cert']}")


if __name__ == "__main__":
    main()
