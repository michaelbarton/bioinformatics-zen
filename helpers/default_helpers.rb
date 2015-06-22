module DefaultHelpers

  def twitter(text=nil)
    text ||= '@' + data.config[:author][:twitter]
    "<a href='http://twitter.com/#{data.config[:author][:twitter]}'>#{text}</a>"
  end

  def urlify(url)
    url
  end

  def amzn(file)
    File.join "http://s3.amazonaws.com/bioinformatics-zen/", file
  end

  def stylesheet(location, media = 'screen,projection')
    "<link href='#{location}' media='#{media}' rel='stylesheet' type='text/css'>"
  end

  def highlight
    "<pre class=\"prettyprint\">"
  end

  def endhighlight
    "</pre>"
  end

  def scripts
    return unless data.config[:scripts]
    output = String.new
    data.config[:scripts].each do |script|
      output << "<script src='#{script}' type='text/javascript'></script>\n"
    end
    output
  end

  def stylesheets
    return unless data.config[:stylesheets]
    output = String.new
    data.config[:stylesheets].each do |sheet,media|
      sheet = sheet.to_s
      output << stylesheet(sheet,media) + "\n"
    end
    output
  end

  def favicon
    if data.config[:site][:favicon]
      return "<link href='#{data.config[:site][:favicon]}' rel='shortcut icon' >"
    end
  end

  def site_title
    "Site title not implemented"
    #(@item[:long_title] || @item[:title]) + ' &middot; ' + data.config[:site][:title]
  end

  def time_for(time)
    Time.parse(time).xmlschema
  end

  def pretty_date(item)
    Time.parse(item[:created_at]).strftime('%b %d %y')
  end

  def js(source)
    "<script src='#{source}' type='text/javascript'></script>"
  end

end
