module ArticleWriter
  def self.write(target_file, article, title, host)
    File.open(target_file, 'w') do |outfile|
      outfile.puts "<html><head><title>#{title}</title></head>"
      outfile.puts "<h2>#{title}</h2><p>#{host}</p><hr>"
      outfile.puts article
      outfile.puts "</body></html>"
    end
  end
end
