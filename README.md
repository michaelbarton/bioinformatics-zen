# Bioinformatics Zen Eleventy Blog

## Build

```
make build
```

Runs `make fmt_check` then `npm run build` (SASS compilation followed by
Eleventy). The build fails if any checked file is not correctly formatted.

To auto-format before building:

```
make fmt && make build
```

## Structure

- `eleventy.config.js` — Eleventy configuration (plugins, shortcodes, filters)
- `_layouts/` — Page layouts (`default.njk`, `post.njk`)
- `_data/metadata.js` — Site-wide metadata (title, URL, author)
- `post/` — Blog posts (`.md` for markdown, `.html` for HTML posts with Liquid)
- `scss/` — Source stylesheets (compiled to `_site/css/` at build time)
- `js/` — Client-side scripts (copied to `_site/js/` at build time)

## Shortcodes

Component partials are registered as Eleventy shortcodes and can be used from
any template:

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
HTML files in `post/` are excluded (they contain Liquid template syntax).

## Stylesheets

Stylesheets are in `scss/`. The `sass:watch` script in `package.json` compiles
them to `_site/css/`. `addWatchTarget` in the Eleventy config rebuilds the site
when they change.

## Deployment

Relies on AWS credentials set as environment variables:

- `S3_BUCKET`
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_DEFAULT_REGION`

```
make deploy
```

[Required environment variables][env]

[env]: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html

## Style PRs

Pull requests that change `scss/styles.scss` or `_layouts/default.njk` must
include before/after screenshots. Capture them with:

```bash
# Before
git stash && make build
cd _site && python3 -m http.server 8765 &
node scripts/screenshot.js /tmp/screenshots-before
kill $(lsof -t -i:8765)

# After
git stash pop && make build
cd _site && python3 -m http.server 8765 &
node scripts/screenshot.js /tmp/screenshots-after
kill $(lsof -t -i:8765)
```

Copy screenshots to `.github/screenshots/before/` and `.github/screenshots/after/`,
then upload to the PR branch via the GitHub Contents API (bypassing the local
git push proxy):

```bash
GITHUB_TOKEN=<token> python3 scripts/upload_screenshots.py owner/repo pr-head-branch
```

Embed them in the PR body using `raw.githubusercontent.com` URLs:

```markdown
| Viewport | Before | After |
|----------|--------|-------|
| Mobile 375px – homepage | ![before](https://raw.githubusercontent.com/owner/repo/BRANCH/.github/screenshots/before/homepage-mobile-375.png) | ![after](…) |
| Mobile 375px – post     | ![before](…) | ![after](…) |
| Desktop – homepage      | ![before](…) | ![after](…) |
```
