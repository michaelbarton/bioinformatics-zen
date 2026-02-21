const { DateTime } = require("luxon");
const pluginRss = require("@11ty/eleventy-plugin-rss");
const embedYouTube = require("eleventy-plugin-youtube-embed");
const markdownIt = require("markdown-it");
const markdownItFootnote = require("markdown-it-footnote");
const syntaxHighlight = require("@11ty/eleventy-plugin-syntaxhighlight");

module.exports = function (config) {
  // Use a different markdown renderer so that footnotes can be created.
  // See: https://www.alpower.com/tutorials/configuring-footnotes-with-eleventy/
  let markdownLib = markdownIt({
    html: true, // Enable HTML tags in source
    breaks: false, // Don't convert '\n' in paragraphs into <br>
    linkify: true, // Autoconvert URL-like text to links
  }).use(markdownItFootnote);

  config.setLibrary("md", markdownLib);

  // Add a nunjucks filter to make the dates more readable.
  // See: https://mrqwest.co.uk/blog/making-dates-readable-11ty-luxon/
  config.addFilter("readableDate", (dateObj) => {
    return DateTime.fromJSDate(dateObj, { zone: "utc" }).toFormat(
      "yyyy.LLL.dd"
    );
  });

  config.addCollection("feedPosts", function (collection) {
    return collection.getAll().filter((item) => item.feed);
  });

  // Shortcodes replacing the _includes partials.
  config.addShortcode("image", function (url, alt, width = 480, cls = "") {
    return `<div class="centred ${cls}"><img src="${url}" alt="${alt}" width="${width}px" class="responsive-image"/></div>`;
  });

  config.addShortcode(
    "image_with_caption",
    function (url, anchor, short_desc, long_desc = "") {
      const id = anchor ? ` id="${anchor}"` : "";
      const extra = long_desc ? ` ${long_desc}` : "";
      return `<figure${id}><img src="${url}"><figcaption><p><strong>${short_desc}</strong>${extra}</p></figcaption></figure>`;
    }
  );

  config.addShortcode("caption", function (short_desc, long_desc = "") {
    return `<figcaption><p><strong>${short_desc}</strong> ${long_desc}</p></figcaption>`;
  });

  // add support for syntax highlighting
  config.addPlugin(syntaxHighlight);

  // Embed youtube videos and other media in markdown files
  config.addPlugin(embedYouTube);

  // Create an RSS feed
  config.addPlugin(pluginRss);

  return {
    dir: {
      layouts: "_layouts",
    },
  };
};
