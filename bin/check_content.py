#!/usr/bin/env python3
"""
Content validation checks for the built site.

Scope: feed posts only (posts with `feed: true` in frontmatter).
These are the actively maintained posts.

1. Verify that every feed post using :::lede produces a
   <div class="lede"> element in the corresponding built HTML.

2. Verify that all external image URLs in feed post HTML return HTTP 200.
"""

import re
import sys
import urllib.request
import urllib.error
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path

SITE_DIR = Path("_site")
POSTS_DIR = Path("post")


def is_feed_post(md_file: Path) -> bool:
    """Return True if the post has feed: true in its frontmatter."""
    text = md_file.read_text()
    return bool(re.search(r"^feed:\s*true\s*$", text, re.MULTILINE))


def get_feed_post_slugs() -> list[str]:
    return [f.stem for f in POSTS_DIR.glob("*.md") if is_feed_post(f)]


def check_lede_rendering(slugs: list[str]) -> list[str]:
    """Return error messages for feed posts where :::lede did not render."""
    errors = []
    for slug in slugs:
        md_file = POSTS_DIR / f"{slug}.md"
        source = md_file.read_text()
        if ":::lede" not in source:
            continue

        html_file = SITE_DIR / "post" / slug / "index.html"
        if not html_file.exists():
            errors.append(f"MISSING built HTML for {md_file}: {html_file}")
            continue

        html = html_file.read_text()
        if '<div class="lede">' not in html:
            errors.append(
                f"LEDE NOT RENDERED in {md_file}: "
                f'expected <div class="lede"> in {html_file}'
            )
    return errors


def check_url(url: str) -> str | None:
    """Return an error string if the URL does not return HTTP 200, else None."""
    try:
        req = urllib.request.Request(url, method="HEAD")
        with urllib.request.urlopen(req, timeout=15) as resp:
            if resp.status != 200:
                return f"HTTP {resp.status}: {url}"
    except urllib.error.HTTPError as exc:
        return f"HTTP {exc.code}: {url}"
    except Exception as exc:
        return f"ERROR ({exc}): {url}"
    return None


def collect_external_image_urls(slugs: list[str]) -> list[str]:
    """Extract external https:// image src values from feed post HTML files."""
    img_pattern = re.compile(r'<img\b[^>]*\bsrc="(https?://[^"]+)"', re.IGNORECASE)
    urls: set[str] = set()
    for slug in slugs:
        html_file = SITE_DIR / "post" / slug / "index.html"
        if html_file.exists():
            for match in img_pattern.finditer(html_file.read_text()):
                urls.add(match.group(1))
    return sorted(urls)


def check_external_images(slugs: list[str]) -> list[str]:
    """Return error messages for any external image URLs that don't return 200."""
    urls = collect_external_image_urls(slugs)
    if not urls:
        return []

    errors = []
    with ThreadPoolExecutor(max_workers=10) as pool:
        futures = {pool.submit(check_url, url): url for url in urls}
        for future in as_completed(futures):
            result = future.result()
            if result:
                errors.append(result)
    return errors


def main() -> int:
    if not SITE_DIR.exists():
        print(
            "ERROR: _site/ directory not found. Run make build first.", file=sys.stderr
        )
        return 1

    slugs = get_feed_post_slugs()
    if not slugs:
        print("WARNING: no feed posts found.")
        return 0

    errors: list[str] = []

    print(f"Checking {len(slugs)} feed post(s): {', '.join(slugs)}")

    print("  Checking lede rendering...")
    errors.extend(check_lede_rendering(slugs))

    print("  Checking external image URLs...")
    errors.extend(check_external_images(slugs))

    if errors:
        print("\nContent check FAILED:", file=sys.stderr)
        for err in sorted(errors):
            print(f"  {err}", file=sys.stderr)
        return 1

    print("All content checks passed.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
