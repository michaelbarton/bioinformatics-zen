#!/usr/bin/env python3
"""Upload before/after screenshots to a GitHub branch via the Contents API.

Usage: GITHUB_TOKEN=<token> python3 scripts/upload_screenshots.py <owner/repo> <branch>

The branch must already exist on github.com. Screenshots are read from
.github/screenshots/before/ and .github/screenshots/after/.
"""

import base64
import json
import os
import sys
import urllib.request


def gh(token, method, path, data=None):
    req = urllib.request.Request(
        f"https://api.github.com{path}",
        method=method,
        headers={
            "Authorization": f"token {token}",
            "Content-Type": "application/json",
        },
    )
    if data:
        req.data = json.dumps(data).encode()
    with urllib.request.urlopen(req) as r:
        return json.loads(r.read())


def upload_screenshots(repo, branch):
    token = os.environ["GITHUB_TOKEN"]
    for side in ("before", "after"):
        for fname in sorted(os.listdir(f".github/screenshots/{side}")):
            path = f".github/screenshots/{side}/{fname}"
            content = base64.b64encode(open(path, "rb").read()).decode()
            existing = gh(token, "GET", f"/repos/{repo}/contents/{path}?ref={branch}")
            payload = {
                "message": f"Add {side} screenshot {fname}",
                "content": content,
                "branch": branch,
            }
            if "sha" in existing:
                payload["sha"] = existing["sha"]
            gh(token, "PUT", f"/repos/{repo}/contents/{path}", payload)
            print(f"Uploaded {path}")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print(f"Usage: {sys.argv[0]} <owner/repo> <branch>")
        sys.exit(1)
    upload_screenshots(sys.argv[1], sys.argv[2])
