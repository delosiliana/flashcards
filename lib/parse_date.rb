require 'open-uri'

class ParseDate
  attr_accessor :url
  attr_accessor :path

  def initialize(new_url, new_path)
    @url = new_url
    @path = new_path
  end

  def parsing
    doc = Nokogiri::HTML(URI.parse(url).open)
    list = doc.xpath(path)
    list.each_slice(2) do |original, translated|
      Card.create(original_text: original.text, translated_text: translated.text)
    end
  end
end
