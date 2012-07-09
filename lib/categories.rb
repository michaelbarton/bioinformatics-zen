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

def longform_articles
  sorted_articles.select{|i| i[:type] == 'longform' && (! i[:unpublished])}
end
