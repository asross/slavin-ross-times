require 'nokogiri'
require 'pry'
require 'json'
require 'date'

articles = Dir.glob('articles/latimes/*.html').map do |f|
  html = Nokogiri.parse(File.read(f))
  html.css('.enhancement').remove
  {
    'org' => 'the Los Angeles Times',
    'author' => 'Michael Ross',
    'title' => html.css('h1.headline').text.strip,
    'date' => DateTime.parse(html.css('time')[0].attributes['datetime'].value).strftime('%B %-d, %Y'),
    'text' => html.css('[data-element="story-body"]').inner_html
  }
end

File.open('articles_from_latimes_html.json', 'w') do |f|
  f.write(JSON.pretty_generate(articles))
end
