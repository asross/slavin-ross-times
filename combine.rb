require 'json'

File.open('articles.json', 'w') do |f|
  f.write(
    JSON.pretty_generate(
      JSON.parse(File.read('articles_from_pdf.json')) +
      JSON.parse(File.read('articles_from_latimes_html.json'))
    )
  )
end
