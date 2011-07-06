include Nanoc3::Helpers::Rendering
include Nanoc3::Helpers::LinkTo
include Nanoc3::Helpers::Blogging

def highlight
  "<pre class=\"class=prettyprint\">"
end

def endhighlight
  "</pre>"
end

def google_font(name,character_sets = [])
  unless character_sets.empty?
    name += ':'
    name += character_sets * ','
  end
  link = "http://fonts.googleapis.com/css?family=#{name}&amp;subset=latin"
  "<link href='#{link}' media='all' type='application/x-font-woff'>"
end

def stylesheet(location, media = 'screen,projection')
  "<link href='#{location}' media='#{media}' rel='stylesheet' type='text/css'>"
end

def site_title
 [@item[:title],@site.config[:title],@site.config[:name]].compact.uniq * " | "
end

def time_for(time)
  Time.parse(time).xmlschema
end

def pretty_date(item)
  Time.parse(item[:created_at]).strftime('%b %d %y')
end

def image(url,width=400,options={})
  link = "<img src='#{relative_path_to(url)}' width=#{width}>"
  if options[:link]
    link = "<a href='#{relative_path_to(options[:link])}'>#{link}</a>"
  end
  link
end

def youtube(video,title="YouTube")
  "<a href=\"http://www.youtube.com/watch?v=#{video}\" rel=\"prettyPhoto\" title=\"#{video}\"><img src=\"http://img.youtube.com/vi/#{video}/0.jpg\" alt=\"#{title}\"/></a>"
end
