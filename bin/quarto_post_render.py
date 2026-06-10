#!/usr/bin/env python3
"""Quarto post-render hook: convert rendered HTML into Eleventy-compatible
fragments and relocate image assets into /assets/posts/<slug>/."""

import os
import re
import shutil
import sys
from datetime import date
from pathlib import Path

from bs4 import BeautifulSoup

REPO_ROOT = Path(__file__).parent.parent


def slug_from(path: Path) -> str:
    return path.parent.name


def read_qmd_date(qmd: Path) -> str:
    text = qmd.read_text(encoding="utf-8")
    m = re.search(r"^---\n(.*?)\n---", text, re.DOTALL | re.MULTILINE)
    if not m:
        return ""
    for line in m.group(1).splitlines():
        if line.startswith("date:"):
            value = line.split(":", 1)[1].strip().strip('"').strip("'")
            if value == "today":
                return date.today().isoformat()
            return value
    return ""


def process(rendered_html: Path) -> None:
    quarto_dir = rendered_html.parent
    slug = slug_from(rendered_html)
    qmd = quarto_dir / "index.qmd"

    soup = BeautifulSoup(rendered_html.read_text(encoding="utf-8"), "lxml")
    title_tag = soup.find("title")
    title = title_tag.get_text(strip=True) if title_tag else slug
    date_str = read_qmd_date(qmd)

    # With `theme: none`, Quarto emits content directly into <body> with no <main> wrapper.
    main = soup.find("main") or soup.body
    if main is None:
        sys.exit(f"ERROR: no <main> or <body> found in {rendered_html}")

    head_styles = "\n".join(str(s) for s in soup.head.find_all("style")) if soup.head else ""

    assets_dir = REPO_ROOT / "assets" / "posts" / slug
    assets_dir.mkdir(parents=True, exist_ok=True)
    for img in main.find_all("img"):
        src = img.get("src", "")
        if not src or src.startswith(("http://", "https://", "/", "data:")):
            continue
        src_path = (quarto_dir / src).resolve()
        if not src_path.exists():
            print(f"WARN: image not found, skipping: {src_path}", file=sys.stderr)
            continue
        dst = assets_dir / src_path.name
        shutil.copy2(src_path, dst)
        img["src"] = f"/assets/posts/{slug}/{src_path.name}"

    frontmatter = (
        f"---\ntags: post\nlayout: post\n"
        f'title: "{title}"\ndate: {date_str}\n---\n'
    )
    body = head_styles + "\n" + main.decode_contents()

    out = REPO_ROOT / "post" / f"{slug}.html"
    out.write_text(frontmatter + body, encoding="utf-8")
    print(f"Written: {out.relative_to(REPO_ROOT)}")


def main() -> None:
    outputs = os.environ.get("QUARTO_PROJECT_OUTPUT_FILES", "").strip().splitlines()
    if not outputs:
        sys.exit("ERROR: QUARTO_PROJECT_OUTPUT_FILES is empty; run via `quarto render`.")
    for o in outputs:
        process(Path(o).resolve())


if __name__ == "__main__":
    main()
