require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

before do
  @contents = File.readlines("data/toc.txt")
end

helpers do
  def in_paragraphs(chapter_content)
    chapter_content.split("\n\n").map do |paragraph|
      "<p>#{paragraph}</p>"
    end.join
  end

  def search_files(file_names, query)
    file_names.map do |file_name|
      file = File.read("#{file_name}")

      next unless !!file.match(/#{query}/)

      chapter_num = file_name.scan(/\d+/).join
      title = @contents[chapter_num.to_i - 1]

      "<li><a href='/chapter/#{chapter_num}'>#{title}</a></li>"
    end.join
  end

  def search_results(query)
    return if query.nil?

    file_names = Dir.glob("data/chp*.txt")
    message = "<p>Sorry, no matches were found</p>"

    result = search_files(file_names, query)

    return message if result.empty?
    result
  end
end

get "/" do
  @title = "The Adventures of Sherlock Holmes"

  erb :home
end

get "/chapter/:number" do
  number = params[:number]

  index = number.to_i - 1
  chapter_title = @contents[index]

  redirect "/" unless (1..@contents.size).cover? number.to_i

  @title = "Chapter #{number}: #{chapter_title}"

  @chapter = File.read("data/chp#{number}.txt")

  erb :chapter
end

get "/search" do
  @query = params[:query]
  erb :search
end

not_found do
  redirect "/"
end
