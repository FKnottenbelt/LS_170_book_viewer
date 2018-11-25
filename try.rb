def find_title(string)
end

  def search_files(file_names, query)
    file_names.map do |file_name|
      file = File.read("#{file_name}")
      !!file.match(/#{query}/)
      next unless !!file.match(/#{query}/)
      "got past next for #{file_name}"
      chapter_num = file_name.scan(/\d+/).join
      title = find_title(chapter_num) || "nnb"

      "<li><a href='/chapter/#{chapter_num}'>#{title}</a></li>"
    end.join
  end

 def search_results(query)
    file_names = Dir.glob("data/chp*.txt")
    message = "<li>Sorry, no matches were found</li>"
    p "and I found this:"
    p result = search_files(file_names, query)
    p '---'
    return message if result.empty?
    result

  end

p search_results("femke")