require 'rainpress'
require 'jsmin'

# Copied from Arjan van der Gaag's nanoc template
# https://github.com/avdgaag/nanoc-template/blob/master/lib/minify_filter.rb

# This filter can process javascript and stylesheet files and based on their
# extension it applies Rainpress or JSMin to its contents.
class MinifyFilter < Nanoc3::Filter
  identifier :minify
  def run(content, args = {})
    case @item[:extension]
    when 'scss' then Rainpress.compress(content)
    when 'js'   then JSMin.minify(content)
    else
      content
    end
  end
end
