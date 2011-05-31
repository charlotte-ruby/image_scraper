require 'rails'
require 'open-uri'
require 'nokogiri'
require 'css_parser'

module ImageScraper
  class Railtie < Rails::Railtie
  end

  def self.image_urls(url, options={})
    options.reverse_merge!({:convert_to_absolute_url=>true,:include_css_images=>true})
    doc = Nokogiri::HTML(open url)
    images = page_images(doc,url,options)
    images += stylesheet_images(doc) if options[:include_css_images]
    images
  end
  
  def self.page_images(doc,url,options)
    uri = URI.parse(url)
    domain = "#{uri.scheme}://#{uri.host}"
    urls = []
    doc.xpath("//img").each do |img|
      image = img["src"]
      image = domain + image if options[:convert_to_absolute_url] and !image.include?("://")
      urls << image
    end
    urls
  end
  
  def self.stylesheet_images(doc)
    find_stylesheets(doc).each do |stylesheet|
      parser = CssParser::Parser.new
      parser.load_uri!(stylesheet)
    end
  end
  
  def self.find_stylesheets(doc)
    stylesheets = []
    doc.xpath('//link').each do |stylesheet|
      p stylesheet.inspect
      #stylesheets << stylesheet
    end
    stylesheets
  end
end