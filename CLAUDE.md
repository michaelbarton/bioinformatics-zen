# CLAUDE.md

## Build

```
make build
```

Runs `make fmt_check` then `npm run build`. To auto-format first: `make fmt && make build`.

## Structure

- `eleventy.config.js` — Eleventy configuration (plugins, shortcodes, filters)
- `_layouts/` — Page layouts (`default.njk`, `post.njk`)
- `_data/metadata.js` — Site-wide metadata (title, URL, author)
- `post/` — Blog posts (`.md` for markdown, `.html` for HTML posts with Liquid)
- `scss/` — Source stylesheets (compiled to `_site/css/` at build time)
- `js/` — Client-side scripts (copied to `_site/js/` at build time)

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
