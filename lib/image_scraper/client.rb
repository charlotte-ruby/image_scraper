module ImageScraper
  class Client
    attr_accessor :url, :convert_to_absolute_url, :include_css_images, :include_css_data_images, :doc

    def initialize(url,options={})
      options.reverse_merge!(:convert_to_absolute_url=>true,:include_css_images=>true, :include_css_data_images=>false)
      @url = URI.escape(url)
      @convert_to_absolute_url = options[:convert_to_absolute_url]
      @include_css_images = options[:include_css_images]
      @include_css_data_images = options[:include_css_data_images]
      html = open(@url).read rescue nil
      @doc = html ? Nokogiri::HTML(html) : nil
    end

    def image_urls
      images = page_images
      images += stylesheet_images if include_css_images
      images
    end

    def page_images
      urls = []
      return urls if doc.blank?
      doc.xpath("//img").each do |img|
        next if img["src"].blank?
        image = URI.escape(img["src"].strip)
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
          image_url = URI.escape image_url[0]
          if image_url.include?("data:image") and @include_css_data_images
            image_url
          else
            image_url = ImageScraper::Util.strip_quotes(image_url)
            @convert_to_absolute_url ? ImageScraper::Util.absolute_url(stylesheet, image_url) : image_url
          end
        end
      end
      images
    end

    def stylesheets
      return [] if doc.blank?
      doc.xpath('//link[@rel="stylesheet"]').collect do |stylesheet|
        ImageScraper::Util.absolute_url url, URI.escape(stylesheet['href'])
      end
    end
  end
end
