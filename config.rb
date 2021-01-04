activate :directory_indexes
activate :livereload
activate :syntax

activate :s3_sync do |s3_sync|
  s3_sync.bucket                = 'www.bioinformaticszen.com'
  s3_sync.region                = 'us-west-1'
  s3_sync.acl                   = 'public-read'
end

activate :blog do |blog|
  blog.permalink = "post/{short}/index.html"
  blog.sources   = "content/:category/:short.html"
end

set :css_dir,      'stylesheets'
set :js_dir,       'javascript'
set :images_dir,   'images'
set :partials_dir, 'partials'

configure :build do
  activate :minify_css
  activate :minify_javascript
  activate :asset_hash
end

after_configuration do
	sprockets.append_path File.join(root, "vendor")
end

# silence i18n warning
::I18n.config.enforce_available_locales = false

page "*",         :layout => "layouts/default"
page "/",         :layout => "layouts/front-page"
page "/atom.xml", :layout => false
