def categories
  @items.select{|i| i && i[:category]}.inject(Hash.new) do |hash,item|
    hash[item[:category]] ||= Array.new
    hash[item[:category]] << item
    hash
  end
end

def sorted_categories
  categories.keys.sort_by{|i| categories[i].length }.reverse
end

def articles_in_category(category)
  sorted_articles.select{|i| i[:category] == category && (! i[:unpublished]) }
end

def published_articles
  sorted_articles.select{|i| ! i[:unpublished]}
end

def series?(item)
  item[:category] && articles_in_category(item[:category]).size > 2
end

def series_articles(item)
  articles_in_category(item[:category]) - [item]
end
