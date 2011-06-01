require 'pp'
require 'rails'
require 'open-uri'
require 'nokogiri'

module ImageScraper
  class Client
    attr_accessor :url, :convert_to_absolute_url, :include_css_images, :include_css_data_images, :doc
    
    def initialize(url,options={})
      options.reverse_merge!(:convert_to_absolute_url=>true,:include_css_images=>true, :include_css_data_images=>false)
      @url = url
      @convert_to_absolute_url = options[:convert_to_absolute_url]
      @include_css_images = options[:include_css_images]
      @include_css_data_images = options[:include_css_data_images]
      @doc = Nokogiri::HTML(open url)
    end
  
    def image_urls
      images = page_images
      images += stylesheet_images if include_css_images
      images
    end
    
    def page_images
      urls = []
      doc.xpath("//img").each do |img|
        image = img["src"]
        image = ImageScraper::Util.absolute_url(url,image) if convert_to_absolute_url
        urls << image
      end
      urls
    end
    
    def stylesheet_images
      images = []
      stylesheets.each do |stylesheet|
        file = open(stylesheet)
        css = file.string rescue IO.read(file)
        
        images += css.scan(/url\((.*?)\)/).collect do |image_url|
          if image_url.include?("data:image") and @include_css_data_images
            image_url[0]
          else
            @convert_to_absolute_url ? ImageScraper::Util.absolute_url(url,image_url[0]) : image_url
          end
        end
      end
      images
    end
    
    def stylesheets
      doc.xpath('//link[@rel="stylesheet"]').collect do |stylesheet|
        ImageScraper::Util.absolute_url(url,stylesheet['href'])
      end
    end
  end
  
  module Util
    def self.absolute_url(url,asset=nil)
      return domain(url) + path(url) if asset.nil? and asset.include("://")
      return asset if asset.include?("://")
      return domain(url)+asset if asset[0]=="/"
      return domain(url) =~ /\/$/  ? domain(url)+asset : domain(url)+"/"+asset
    end
    
    def self.domain(url)
      uri = URI.parse(url)
      "#{uri.scheme}://#{uri.host}"
    end
    
    def self.path(url)
      uri = URI.parse(url)
      uri.path
    end
  end
  
  class Railtie < Rails::Railtie
  end
end