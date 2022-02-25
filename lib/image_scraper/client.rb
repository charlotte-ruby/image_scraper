# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'cgi'

module ImageScraper
  class Client
    USER_AGENT = 'Mozilla/5.0 (Macintosh)'

    attr_accessor :url, :convert_to_absolute_url, :include_css_images, :include_css_data_images, :doc
    attr_reader :uri, :error

    def initialize(url, options = {})
      defaults = { convert_to_absolute_url: true, include_css_images: true, include_css_data_images: false }
      options.merge!(defaults)

      @url = url
      @uri = Util.convert_to_uri(url)

      @convert_to_absolute_url = options[:convert_to_absolute_url]
      @include_css_images = options[:include_css_images]
      @include_css_data_images = options[:include_css_data_images]

      begin
        html = fetch(@uri)
      rescue StandardError => e
        @error = e
        html = nil
      end

      @doc = html ? Nokogiri::HTML(html, nil, 'UTF-8') : nil
    end

    def fetch(url, limit = 10)
      raise ArgumentError, 'HTTP redirect too deep' if limit.zero?

      uri = Util.convert_to_uri(url)

      return false unless uri

      result = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.port == 443) do |http|
        request = Net::HTTP::Get.new(uri, { 'User-Agent' => USER_AGENT })
        response = http.request request

        case response
        when Net::HTTPSuccess     then response
        when Net::HTTPRedirection then fetch(response['location'], limit - 1)
        else
          response.error!
        end
      end

      if result.is_a? Net::HTTPOK
        result.body
      elsif result.is_a? String
        result
      end
    end

    def image_urls
      images = page_images
      images += stylesheet_images if include_css_images
      images.sort.uniq
    end

    def cleanup_src_value(text)
      text.to_s.strip!
      text.gsub!(' ', '%20')

      # escape characters that CGI::escape doesn't get
      text.gsub(/([{}|\^\[\]\@`])/) { |s| s }
    end

    def page_images
      return [] if doc.to_s.empty?

      doc.xpath('//img').collect do |e|
        src = cleanup_src_value(e['src'])
        next if src.empty?

        if convert_to_absolute_url
          Util.absolute_url(@uri.to_s, src)
        else
          src
        end
      end.compact
    end

    def fetch_css(url)
      begin
        file = URI.open(url)
      rescue StandardError
        return ''
      end

      begin
        css = file.string
      rescue StandardError
        css = File.read(file)
      rescue StandardError
        return ''
      end

      css.unpack('C*').pack('U*')
    end

    def stylesheet_images
      images = []

      stylesheets.each do |stylesheet|
        css = fetch_css(stylesheet)

        next unless css.to_s.length.positive?

        images += css.scan(/url\((.*?)\)/).collect do |image_url|
          image_url = Util.cleanup_url(image_url[0])
          image_url = image_url.gsub(/([{}|\^\[\]\@`])/) { |s| CGI.escape(s) } # escape characters that URI.escape doesn't get
          if image_url.include?('data:image') && @include_css_data_images
            image_url
          else
            @convert_to_absolute_url ? Util.absolute_url(stylesheet, image_url) : image_url
          end
        end
      end
      images.compact
    end

    def stylesheets
      return [] if doc.to_s.empty?

      doc.xpath('//link[@rel="stylesheet"]').collect do |stylesheet|
        Util.absolute_url(@uri.to_s, Util.cleanup_url(stylesheet['href']))
      end.compact
    end
  end
end
