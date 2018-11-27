require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

before do
  @contents = File.readlines("data/toc.txt")
end

helpers do
  def in_paragraphs(chapter_content)
    chapter_content.split("\n\n").map.with_index do |paragraph, indx|
      "<p id=#{indx}>#{paragraph}</p>"
    end.join
  end

  def each_chapter
    @contents.each_with_index do |name, index|
      number = index + 1
      contents = File.read("data/chp#{number}.txt")
      yield number, name, contents
    end
  end

  def chapters_matching(query)
    results = []

    return results unless query

    each_chapter do |number, name, contents|
      matches = {}
      contents.split("\n\n").each_with_index do |paragraph, index|
        matches[index] = paragraph if paragraph.include?(query)
      end
      results << {number: number, name: name, paragraphs: matches} if matches.any?
    end

    results
  end

  def highlight(tekst, query)
    tekst.gsub(query, "<strong>#{query}</strong>")
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
  #@query = params[:query]
  @results = chapters_matching(params[:query])
  erb :search
end

not_found do
  redirect "/"
end
