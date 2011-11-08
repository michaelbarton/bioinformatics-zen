require 'rack/contrib/try_static'

use Rack::TryStatic, 
    :root => "output",
    :urls => %w[/],
    :try => ['.html', 'index.html', '/index.html']

# Empty app, should never be reached:
class Homepage
  def call(env)
    [404, {"Content-Type" => "text/html"}, ["404. PC LOAD LETTER"] ]
  end
end
run Homepage.new
