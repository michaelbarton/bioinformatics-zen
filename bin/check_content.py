#!/usr/bin/env python3
"""
Content validation checks for the built site.

Scope: feed posts only (posts with `feed: true` in frontmatter).
These are the actively maintained posts.

1. Verify that every feed post using :::lede produces a
   <div class="lede"> element in the corresponding built HTML.

2. Verify that all external URLs referenced in feed post HTML return HTTP 200.
   This covers:
   - <img src="https://..."> (body images)
   - <meta property="og:image" content="https://..."> (social card images)
   - <meta name="twitter:image:src" content="https://..."> (twitter card images)
   - <a href="https://..."> (outbound links)

   Image URLs are additionally checked to ensure the response Content-Type is
   an image MIME type, catching cases where a URL returns HTTP 200 but serves
   an error page or placeholder rather than the actual image.

3. Validate that <img> tags in feed post HTML have well-formed attributes.
   Catches broken HTML from unescaped quotes in attribute values (e.g. alt text
   containing literal double-quote characters), which cause browsers to misparse
   the tag and fail to render the image.
"""

import html as html_module
import re
import sys
import urllib.request
import urllib.error
from concurrent.futures import ThreadPoolExecutor, as_completed
from html.parser import HTMLParser
from pathlib import Path

SITE_DIR = Path("_site")
POSTS_DIR = Path("post")

# Headers that mimic a browser request to avoid false 406 responses from
# servers that reject requests without an Accept header (e.g. Uber's CDN).
_HEADERS = {
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
    "User-Agent": "Mozilla/5.0 (compatible; site-link-checker/1.0)",
}


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


def _fetch(url: str, method: str) -> tuple[int, str]:
    """Make an HTTP request and return (status_code, content_type)."""
    decoded = html_module.unescape(url)
    req = urllib.request.Request(decoded, method=method, headers=_HEADERS)
    with urllib.request.urlopen(req, timeout=15) as resp:
        return resp.status, resp.headers.get("Content-Type", "")


def check_link(url: str) -> str | None:
    """Return an error string if the URL does not return HTTP 200, else None.

    Tries HEAD first; falls back to GET for any 4xx HEAD response.  Some
    servers (e.g. Bluesky) return 404 for HEAD but 200 for GET.  The URL is
    only reported broken if GET also fails.
    """
    last_error: str | None = None
    for method in ("HEAD", "GET"):
        try:
            status, _ = _fetch(url, method)
            if status == 200:
                return None
            last_error = f"HTTP {status}: {url}"
        except urllib.error.HTTPError as exc:
            if method == "HEAD" and 400 <= exc.code < 500:
                last_error = f"HTTP {exc.code}: {url}"
                continue
            return f"HTTP {exc.code}: {url}"
        except Exception as exc:
            return f"ERROR ({exc}): {url}"
    return last_error


def check_image(url: str) -> str | None:
    """Return an error if the URL is not a reachable image.

    Uses GET so we can inspect the Content-Type.  A URL that returns HTTP 200
    with a non-image Content-Type (e.g. an S3 XML error served with 200) is
    flagged as broken.
    """
    try:
        status, content_type = _fetch(url, "GET")
        if status != 200:
            return f"HTTP {status}: {url}"
        if not content_type.lower().startswith("image/"):
            return f"NOT AN IMAGE (Content-Type: {content_type!r}): {url}"
    except urllib.error.HTTPError as exc:
        return f"HTTP {exc.code}: {url}"
    except Exception as exc:
        return f"ERROR ({exc}): {url}"
    return None


# Valid attribute names for <img> elements (HTML spec + common global attrs).
# Attribute names outside this set on an <img> tag indicate broken HTML,
# typically caused by unescaped quotes in a preceding attribute value.
_VALID_IMG_ATTRS = frozenset(
    {
        "src",
        "alt",
        "width",
        "height",
        "class",
        "id",
        "style",
        "title",
        "loading",
        "decoding",
        "srcset",
        "sizes",
        "crossorigin",
        "referrerpolicy",
        "usemap",
        "ismap",
        "longdesc",
        "name",
        "role",
        "hidden",
        "dir",
        "lang",
        "tabindex",
    }
)


class _ImgAttrChecker(HTMLParser):
    """Parse HTML and collect <img> tags with unexpected attribute names."""

    def __init__(self):
        super().__init__()
        self.errors: list[str] = []
        self._file: str = ""

    def check_file(self, html: str, filename: str) -> list[str]:
        self.errors = []
        self._file = filename
        self.feed(html)
        return list(self.errors)

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]):
        if tag != "img":
            return
        attr_names = [name for name, _ in attrs]
        bad = [
            n
            for n in attr_names
            if n not in _VALID_IMG_ATTRS and not n.startswith(("data-", "aria-"))
        ]
        if bad:
            src = next((v for n, v in attrs if n == "src"), "<unknown>")
            self.errors.append(
                f"MALFORMED <img> in {self._file}: "
                f"unexpected attribute(s) {bad!r} "
                f"(likely unescaped quotes in alt text). src={src}"
            )


def check_img_attributes(slugs: list[str]) -> list[str]:
    """Return errors for <img> tags with broken attributes in feed post HTML."""
    checker = _ImgAttrChecker()
    errors: list[str] = []
    for slug in slugs:
        html_file = SITE_DIR / "post" / slug / "index.html"
        if not html_file.exists():
            continue
        html = html_file.read_text()
        errors.extend(checker.check_file(html, str(html_file)))
    return errors


def collect_external_urls(slugs: list[str]) -> dict[str, set[str]]:
    """
    Extract all external URLs from feed post HTML files, grouped by kind.

    Returns a dict with keys 'images' and 'links', each a set of URLs.
    Images covers <img src>, og:image, and twitter:image meta tags.
    Links covers <a href>.
    """
    img_src = re.compile(r'<img\b[^>]*\bsrc="(https?://[^"]+)"', re.IGNORECASE)
    meta_img = re.compile(
        r'<meta\b[^>]*\bcontent="(https?://[^"]+)"[^>]*>', re.IGNORECASE
    )
    meta_image_names = re.compile(
        r'(?:property|name)="(?:og:image|twitter:image[^"]*)"', re.IGNORECASE
    )
    anchor = re.compile(r'<a\b[^>]*\bhref="(https?://[^"]+)"', re.IGNORECASE)

    images: set[str] = set()
    links: set[str] = set()

    for slug in slugs:
        html_file = SITE_DIR / "post" / slug / "index.html"
        if not html_file.exists():
            continue
        html = html_file.read_text()

        for match in img_src.finditer(html):
            images.add(match.group(1))

        for match in meta_img.finditer(html):
            if meta_image_names.search(match.group(0)):
                images.add(match.group(1))

        for match in anchor.finditer(html):
            links.add(match.group(1))

    return {"images": images, "links": links}


def check_external_urls(slugs: list[str]) -> list[str]:
    """Return error messages for any broken external URLs."""
    grouped = collect_external_urls(slugs)
    images = grouped["images"]
    links = grouped["links"]

    tasks: list[tuple] = [(url, "image") for url in sorted(images)] + [
        (url, "link") for url in sorted(links)
    ]
    if not tasks:
        return []

    errors = []
    with ThreadPoolExecutor(max_workers=10) as pool:
        futures = {
            pool.submit(check_image if kind == "image" else check_link, url): url
            for url, kind in tasks
        }
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

    print("  Checking img tag attributes...")
    errors.extend(check_img_attributes(slugs))

    print("  Checking external images and links...")
    errors.extend(check_external_urls(slugs))

    if errors:
        print("\nContent check FAILED:", file=sys.stderr)
        for err in sorted(errors):
            print(f"  {err}", file=sys.stderr)
        return 1

    print("All content checks passed.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
