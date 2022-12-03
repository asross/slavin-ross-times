require "pdf-reader"
require 'pry'
require 'json'

data = []

class Article
  attr_reader :content, :title, :date, :org, :page, :text

  def initialize(pdf)
    @content = pdf.pages.map {|page| page.text}.join
    splits = content.split(/\n+/)
    header1 = splits[0]
    header2 = splits[1]
    @title = header1.split(' - ').first
    @date, @org, @author, @page = header2.split(/\s*\|\s*/)
    rest = content.sub(/\A[^\n]+\n+[^\n]+\n+/, '')
    @text = rest.gsub("\n\n\n", "<br>").gsub(/\n+/, ' ').gsub("<br>", "\n\n")
  end

  def author
    if @author =~ /Ross/i
      'Michael Ross'
    elsif @author =~ /Slavin/i
      'Barbara Slavin'
    else
      @author
    end
  end

  def org
    if @author =~ /Los Angeles/i
      'the Los Angeles Times'
    elsif @author =~ /UPI Senior/ || @author =~ /United Press/
      'United Press International'
    elsif @org == 'UPI (USA)'
      'United Press International'
    else
      s = @org.gsub(/ \(.*\)$/, '').split(',')[0]
      if s =~ /, /
        s = "the " + s
      end
      s
    end
  end

  def as_json
    {
      'author' => author,
      'org' => org,
      'date' => date,
      'title' => title,
      'text' => text.gsub("\n\n", "<br><br>")
    }
  end
end

articles = Dir.glob('articles/*.pdf').map { |f| Article.new(PDF::Reader.new(f)) }

File.open('articles.json', 'w') do |f|
  f.write(JSON.pretty_generate(articles.map(&:as_json)))
end
