require 'open-uri'
require 'nokogiri'

module ImageScraper
  def self.image_urls(url, convert_to_absolute_url=true)
    uri = URI.parse(url)
    domain = "#{uri.scheme}://#{uri.host}"
    doc = Nokogiri::HTML(open url)
    urls = []
    doc.xpath("//img").each do |img|
      image = img["src"]
      image = domain + image if convert_to_absolute_url and !image.include?("://")
      urls << image
    end
    urls
  end
end