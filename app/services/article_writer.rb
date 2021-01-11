module ArticleWriter

  def self.write(target_file, article, title)
    File.open(target_file, 'w') do |outfile|

      outfile.puts "<html><head><title>#{title}</title></head>"

      # Find h1 in article and replace with h4
      if article.at_css "h1"
        headline = article.at_css "h1"
        headline.name = "h4"
      elsif article.at_css "h2"
        headline = article.at_css "h2"
        headline.name = "h4"
      end

      # Add "title" class to h4
      if headline
        headline["class"] = "title"
      end

      # Write article content
      outfile.puts article

      outfile.puts "</body></html>"

    end
  end

end
