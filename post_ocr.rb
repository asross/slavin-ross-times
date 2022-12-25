require 'json'

articles = JSON.parse(File.read('articles.json'))

Dir.glob('ocr/*.txt').each do |f|
  txt = File.read(f)
  parts = txt.split("\n---\n")
  if parts.size == 2
    metadata, text = parts
    metadata = metadata.split("\n").map { |l| l.split(': ') }.to_h
    if metadata.delete('ready') == 'true'
      next if articles.any? { |a| a["title"] == metadata["title"] }
      articles << metadata.merge(
        "text" => text.gsub("\n\n", "<br><br>").strip
      )
      puts articles[-1]
    end
  end
end

File.open('articles.json', 'w') do |f|
  f.write(JSON.pretty_generate(articles))
end
