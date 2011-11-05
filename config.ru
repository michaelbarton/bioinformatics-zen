require 'rack/contrib/try_static'
require 'rack/rewrite'

use Rack::Rewrite do
  r301 /\/([^\/]*)\/([^\/]*)\//, '/post/$2/', :not => /\/post\/.*/
end

use Rack::TryStatic, 
    :root => "output",
    :urls => %w[/],
    :try => ['.html', 'index.html', '/index.html']

# Empty app, should never be reached:
class Homepage
  def call(env)
    [404, {"Content-Type" => "text/html"}, ["Page not found"] ]
  end
end
run Homepage.new
