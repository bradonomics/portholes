module TableOfContents
  def self.create(target_file, files)
    date = Date.today
    title = date.strftime("%A, %b #{date.day.ordinalize}, %Y")

    File.open(target_file, 'w') do |outfile|

      outfile.puts "<html><head><title>Portholes: #{title}</title></head><body><h1>Portholes</h1><h2>#{title}</h2>"

      outfile.puts "<ul>"
      for file in files
        outfile.puts "<li><a href=\"#{file[1]}.html\">#{file[0]}</a></li>"
      end
      outfile.puts "</ul>"

      outfile.puts "</body></html>"

    end
  end
end
