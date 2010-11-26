include Nanoc3::Helpers::Rendering
include Nanoc3::Helpers::LinkTo

def highlight(lang)
  "<pre><code class=\"language-#{lang}\">"
end

def endhighlight
  "</code></pre>"
end
