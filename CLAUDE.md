# CLAUDE.md

## Build

Run the full build (formatter check + site generation):

```
make build
```

This runs `make fmt_check` first, then `npm run build` (SASS compilation followed
by Eleventy). The build will fail if any checked file is not correctly formatted.

To auto-format before building:

```
make fmt && make build
```

## Structure

- `eleventy.config.js` — Eleventy configuration (plugins, shortcodes, filters)
- `_layouts/` — Page layouts (`default.njk`, `post.njk`)
- `_includes/` — (currently empty; component partials are now registered shortcodes)
- `_data/metadata.js` — Site-wide metadata (title, URL, author)
- `post/` — Blog posts (`.md` for markdown, `.html` for HTML posts with Liquid)
- `scss/` — Source stylesheets (compiled to `_site/css/` at build time)
- `js/` — Client-side scripts (copied to `_site/js/` at build time)

## Shortcodes

Component partials are registered as Eleventy shortcodes in `eleventy.config.js`
and can be called from any template language (Liquid in `.md`/`.html` posts,
Nunjucks in layouts):

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

Prettier checks `scss/*`, `post/*`, `eleventy.config.js`, and `package.json`.
HTML files use `printWidth: 9999` (configured in `.prettierrc`) to prevent
line-wrapping inside Liquid shortcode arguments.

`make fmt_check` is a dependency of `make build`, so formatting is enforced on
every build.
