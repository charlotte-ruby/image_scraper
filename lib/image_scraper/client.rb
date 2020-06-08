# frozen_string_literal: true

require 'cgi'
module ImageScraper
  class Client
    attr_accessor :url, :convert_to_absolute_url, :include_css_images, :include_css_data_images, :doc

    def initialize(url, options = {})
      options.reverse_merge!(convert_to_absolute_url: true, include_css_images: true, include_css_data_images: false)
      @url = URI.escape(url)

      # @url = URI.parse(URI.encode(url))

      @convert_to_absolute_url = options[:convert_to_absolute_url]
      @include_css_images = options[:include_css_images]
      @include_css_data_images = options[:include_css_data_images]
      html = begin
               URI.open(@url).read
             rescue StandardError
               nil
             end
      @doc = html ? Nokogiri::HTML(html, nil, 'UTF-8') : nil
    end

    def image_urls
      images = page_images
      images += stylesheet_images if include_css_images
      images
    end

    def page_images
      urls = []
      return urls if doc.blank?

      doc.xpath('//img').each do |img|
        next if img['src'].blank?

        image = URI.escape(img['src'].strip)
        image = image.gsub(/([{}|\^\[\]\@`])/) { |s| URI.escape(s) } # escape characters that CGI::escape doesn't get
        if convert_to_absolute_url
          image = ImageScraper::Util.absolute_url(url, image)
        end
        urls << image
      end
      urls.compact
    end

    def stylesheet_images
      images = []
      stylesheets.each do |stylesheet|
        file = begin
                 URI.open(stylesheet)
               rescue StandardError
                 next
               end
        css = begin
                begin
                                file.string
                rescue StandardError
                  IO.read(file)
                              end
              rescue StandardError
                next
              end
        css = css.unpack('C*').pack('U*')
        images += css.scan(/url\((.*?)\)/).collect do |image_url|
          image_url = URI.escape ImageScraper::Util.cleanup_url(image_url[0])
          image_url = image_url.gsub(/([{}|\^\[\]\@`])/) { |s| CGI.escape(s) } # escape characters that URI.escape doesn't get
          if image_url.include?('data:image') && @include_css_data_images
            image_url
          else
            @convert_to_absolute_url ? ImageScraper::Util.absolute_url(stylesheet, image_url) : image_url
          end
        end
      end
      images.compact
    end

    def stylesheets
      return [] if doc.blank?

      doc.xpath('//link[@rel="stylesheet"]').collect do |stylesheet|
        ImageScraper::Util.absolute_url url, URI.escape(ImageScraper::Util.cleanup_url(stylesheet['href']))
      rescue StandardError
        nil
      end.compact
    end
  end
end
