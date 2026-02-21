#!/usr/bin/env node
/**
 * Capture screenshots at multiple viewports for visual review.
 *
 * Usage:
 *   node scripts/screenshot.js [output-dir]
 *
 * Expects the site to be served at http://localhost:8765.
 * Defaults to /tmp/screenshots; pass a directory as the first argument
 * to override (e.g. /tmp/screenshots-before or /tmp/screenshots-after).
 *
 * Typical workflow:
 *   cd _site && python3 -m http.server 8765 &
 *   node scripts/screenshot.js /tmp/screenshots-after
 *   kill $(lsof -t -i:8765)
 */

const { chromium } = require('/opt/node22/lib/node_modules/playwright');
const fs = require('fs');
const path = require('path');

const DIR = process.argv[2] || '/tmp/screenshots';
if (!fs.existsSync(DIR)) fs.mkdirSync(DIR, { recursive: true });

const MAX_SCREENSHOT_HEIGHT = 2000;

const viewports = [
  { name: 'mobile-375',   width: 375,  height: 667  },
  { name: 'tablet-768',   width: 768,  height: 1024 },
  { name: 'desktop-1280', width: 1280, height: 900  },
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
      const file = path.join(DIR, `${pg.name}-${vp.name}.png`);
      const pageHeight = await page.evaluate(() => document.body.scrollHeight);
      const clipHeight = Math.min(pageHeight, MAX_SCREENSHOT_HEIGHT);
      await page.screenshot({ path: file, clip: { x: 0, y: 0, width: vp.width, height: clipHeight } });
      console.log(`Saved ${file}`);
    }
    await ctx.close();
  }
  await browser.close();
})();
