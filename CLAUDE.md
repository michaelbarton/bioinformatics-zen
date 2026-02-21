# Claude Code Guidelines

## Build

```
make build
```

Runs `make fmt_check` then `npm run build`. To auto-format first: `make fmt && make build`.

## Shortcodes

```liquid
{% image "url", "alt text" %}
{% image "url", "alt text", 640 %}
{% image "url", "alt text", 640, "css-class" %}

{% image_with_caption "url", "anchor-id", "Short description." %}
{% image_with_caption "url", "anchor-id", "Short desc.", "Long description." %}

{% caption "Short description." %}
{% caption "Short description.", "Long description." %}
```

## Formatting

Prettier checks `scss/*`, `post/*.md`, `eleventy.config.js`, and `package.json`.
HTML files in `post/` are excluded (contain Liquid template syntax).

## Style Review Process

Any change to `scss/styles.scss` or `_layouts/default.njk` **must** be reviewed
with real screenshots before committing. Do not reason about CSS changes in the
abstract — render and look.

### Workflow

1. **Capture before screenshots** (before touching any files)
2. Make style changes
3. Rebuild: `make build`
4. **Capture after screenshots**
5. Read both sets of images and inspect them carefully
6. Identify and fix any issues found, then repeat from step 3
7. Only commit once the after screenshots look correct at all viewports

### Taking Screenshots

Start a local server, run `scripts/screenshot.js`, then kill the server.
Pass an output directory as the first argument (defaults to `/tmp/screenshots`).

```bash
cd _site && python3 -m http.server 8765 &
node scripts/screenshot.js /tmp/screenshots
kill $(lsof -t -i:8765)
```

Read the resulting PNG files directly — Claude can view images.

### What to Check in Screenshots

- **Mobile (375px)**: Nav links visible without hamburger menu; post list dates
  on their own line above titles; no horizontal overflow; headings not
  oversized; adequate spacing around site title
- **Tablet (768px)**: Date and title on same line; container comfortably
  narrower than viewport; code blocks contained
- **Desktop (1280px)**: Centred column looks intentional, not lost; clean
  typographic hierarchy

## Pull Requests for Style Changes

Include before/after screenshots in the PR body. Capture "before" by
stashing changes, building, screenshotting, then unstashing.

```bash
git stash
make build
cd _site && python3 -m http.server 8765 &
node scripts/screenshot.js /tmp/screenshots-before
kill $(lsof -t -i:8765)
git stash pop
make build
cd _site && python3 -m http.server 8765 &
node scripts/screenshot.js /tmp/screenshots-after
kill $(lsof -t -i:8765)
```

Drag the PNG files into the GitHub PR comment box to upload them, then
embed the resulting URLs in a side-by-side table:

```markdown
## Screenshots

| Viewport | Before | After |
|----------|--------|-------|
| Mobile 375px – homepage | ![before](…) | ![after](…) |
| Mobile 375px – post     | ![before](…) | ![after](…) |
| Desktop – homepage      | ![before](…) | ![after](…) |
```

Do not commit screenshot files to the repository.
