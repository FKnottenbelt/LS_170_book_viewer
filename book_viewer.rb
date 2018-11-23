require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  @contents = File.readlines("data/toc.txt")

  erb :home
end

get "/chapter/:number" do
  number = params[:number]

  @contents = File.readlines("data/toc.txt")
  index = number.to_i - 1
  chapter_title = @contents[index]

  @title = "Chapter #{number}: #{chapter_title}"

  @chapter = File.read("data/chp#{number}.txt").split("\n\n")

  erb :chapter
end