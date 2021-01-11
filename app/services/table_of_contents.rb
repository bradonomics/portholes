module TableOfContents
  def self.create(target_file, files)
    File.open(target_file, 'w') do |outfile|

      outfile.puts "<html><head><title>Brad's Title</title></head><body><h2>Brad's Title</h2><h4>Brad's Sub Title</h4>"

      outfile.puts "<ul>"
      for file in files
        outfile.puts "<li><a href=\"#{file[1]}.html\">#{file[0]}</a></li>"
      end
      outfile.puts "</ul>"

      outfile.puts "</body></html>"

    end
  end
end
