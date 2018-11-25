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

  def find_title(chapter_num)
     @contents[chapter_num.to_i - 1]
  end

  def search_results(query)
    files_names = Dir.glob("data/chp*.txt")

    files_names.map do |file_name|
      file = File.read("#{file_name}")
      next unless !!file.match(/#{query}/)

      chapter_num = file_name.scan(/\d+/).join
      title = find_title(chapter_num) || "nnb"

      "<li><a href='/chapter/#{chapter_num}'>#{title}</a></li>"
    end.join
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
