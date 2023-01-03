const { DateTime } = require("luxon");
const pluginRss = require("@11ty/eleventy-plugin-rss");
const embedYouTube = require("eleventy-plugin-youtube-embed");
const markdownIt = require("markdown-it");
const markdownItFootnote = require("markdown-it-footnote");
const syntaxHighlight = require("@11ty/eleventy-plugin-syntaxhighlight");

module.exports = function (config) {
  // Use a different markdown renderer so that footnotes can be created.
  // See: https://www.alpower.com/tutorials/configuring-footnotes-with-eleventy/
  let options = {
    html: true, // Enable HTML tags in source
    breaks: false, // Don't convert '\n' in paragraphs into <br>
    linkify: true, // Autoconvert URL-like text to links
  };

  // configure the library with options
  let markdownLib = markdownIt(options)
		.use(markdownItFootnote)
		// Render custom `lede` fenced blocks.
		.use(require("markdown-it-container"), 'lede', {});

  // set the library to process markdown files
  config.setLibrary("md", markdownLib);

  // Don't try and do anything to these directories, just copy through.
  // See: https://michaelsoolee.com/add-css-11ty/
  config.addPassthroughCopy("css");
  config.addPassthroughCopy("js");

  // Rebuild the site if the scss file changes.
  config.addWatchTarget("./scss");
  config.setBrowserSyncConfig({
    files: "./_site/css/styles.css",
  });

  // The compiled CSS file is ignored by git.
  // By default eleventy will ignore any files in the .ignore
  // https://www.belter.io/eleventy-sass-workflow/
  config.setUseGitIgnore(false);

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

  // add support for syntax highlighting
  config.addPlugin(syntaxHighlight);

  // Embed youtube videos and other media in markdown files
  config.addPlugin(embedYouTube);

  // Create an RSS feed
  config.addPlugin(pluginRss);

  return {
    passthroughFileCopy: true,
  };
};
