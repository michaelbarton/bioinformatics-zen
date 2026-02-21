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

Start a local server, run the Playwright script below, then kill the server.

```bash
cd _site && python3 -m http.server 8765 &
node /tmp/screenshot.js
kill $(lsof -t -i:8765)
```

**`/tmp/screenshot.js`** — write this file before running:

```javascript
const { chromium } = require('/opt/node22/lib/node_modules/playwright');
const fs = require('fs');

const DIR = '/tmp/screenshots';
if (!fs.existsSync(DIR)) fs.mkdirSync(DIR);

const viewports = [
  { name: 'mobile-375',  width: 375,  height: 667  },
  { name: 'tablet-768',  width: 768,  height: 1024 },
  { name: 'desktop-1280', width: 1280, height: 900 },
];

const pages = [
  { name: 'homepage', path: '/' },
  { name: 'post',     path: '/post/pytest-api-examples/' },
];

(async () => {
  const browser = await chromium.launch({ headless: true });
  for (const vp of viewports) {
    const ctx = await browser.newContext({ viewport: { width: vp.width, height: vp.height } });
    const page = await ctx.newPage();
    for (const pg of pages) {
      await page.goto('http://localhost:8765' + pg.path, { waitUntil: 'domcontentloaded' });
      await page.screenshot({ path: `${DIR}/${pg.name}-${vp.name}.png`, fullPage: true });
    }
    await ctx.close();
  }
  await browser.close();
})();
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
# take before screenshots (use /tmp/screenshots-before as DIR in the script)
git stash pop
make build
# take after screenshots (use /tmp/screenshots-after as DIR)
```

Then embed in the PR with a side-by-side table:

```markdown
## Screenshots

| Viewport | Before | After |
|----------|--------|-------|
| Mobile 375px – homepage | ![before](…) | ![after](…) |
| Mobile 375px – post     | ![before](…) | ![after](…) |
| Desktop – homepage      | ![before](…) | ![after](…) |
```

Upload the PNG files as PR attachments (drag into the GitHub comment box) to
get the URLs for the table.
