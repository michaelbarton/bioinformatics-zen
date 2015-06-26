module DefaultHelpers

  def amzn(file)
    File.join "http://s3.amazonaws.com/bioinformatics-zen/", file
  end

  def pretty_date(item)
    Time.parse(item).strftime('%a %B %e %Y')
  end

end
