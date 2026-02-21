# Claude Code Guidelines

## Build

`make build` — runs `make fmt_check` then `npm run build`.
To auto-format first: `make fmt && make build`.

See README for shortcodes, formatting scope, and deployment details.

## Style Review Process

Any change to `scss/styles.scss` or `_layouts/default.njk` **must** be reviewed
with real screenshots before committing. Do not reason about CSS changes in the
abstract — render and look.

### Workflow

1. Capture before screenshots (before touching any files)
2. Make style changes
3. Rebuild: `make build`
4. Capture after screenshots
5. Read both image sets and inspect carefully
6. Fix any issues found, then repeat from step 3
7. Commit only once after screenshots look correct at all viewports

### Taking Screenshots

```bash
cd _site && python3 -m http.server 8765 &
node scripts/screenshot.js /tmp/screenshots
kill $(lsof -t -i:8765)
```

### What to Check

- **Mobile (375px)**: Nav links visible; post list dates on own line above titles;
  no horizontal overflow; headings not oversized; adequate spacing around site title
- **Tablet (768px)**: Date and title on same line; container narrower than viewport;
  code blocks contained
- **Desktop (1280px)**: Centred column looks intentional; clean typographic hierarchy

## Pull Requests for Style Changes

Include before/after screenshots in the PR body. See README for the full workflow
and screenshot table format.

```bash
git stash && make build
cd _site && python3 -m http.server 8765 &
node scripts/screenshot.js /tmp/screenshots-before
kill $(lsof -t -i:8765)
git stash pop && make build
cd _site && python3 -m http.server 8765 &
node scripts/screenshot.js /tmp/screenshots-after
kill $(lsof -t -i:8765)
```

Save to `.github/screenshots/before/` and `.github/screenshots/after/` **on
disk only — never `git add` them**. The directory is in `.gitignore` and a
pre-commit hook will reject any attempt to commit screenshots.

Upload directly to GitHub via (bypasses the local git push proxy):

```bash
GITHUB_TOKEN=<token> python3 scripts/upload_screenshots.py owner/repo pr-head-branch
```
