# frozen_string_literal: true

require 'spec_helper'
require 'image_scraper'

describe ImageScraper::Client do
  describe "#initialize" do
    it 'works with invalid URLs' do
      scraper = described_class.new('couponshack.com')

      expect(scraper.doc).to be(nil)
    end

    it 'has empty data if URL is invalid' do
      scraper = described_class.new('couponshack.com')

      expect(scraper.image_urls).to be_empty
      expect(scraper.stylesheets).to be_empty
      expect(scraper.stylesheet_images).to be_empty
      expect(scraper.page_images).to be_empty
    end
  end

  describe '#image_urls' do
    it 'scrapes absolute paths' do
      images = [
        'http://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/SIPI_Jelly_Beans_4.1.07.tiff/lossy-page1-220px-SIPI_Jelly_Beans_4.1.07.tiff.jpg',
        'http://upload.wikimedia.org/wikipedia/en/thumb/5/5c/Symbol_template_class.svg/16px-Symbol_template_class.svg.png',
        'http://upload.wikimedia.org/wikipedia/en/thumb/5/5c/Symbol_template_class.svg/16px-Symbol_template_class.svg.png',
        'http://en.wikipedia.org/wiki/Special:CentralAutoLogin/start?type=1x1',
        'http://en.wikipedia.org/static/images/wikimedia-button.png',
        'http://en.wikipedia.org/static/images/poweredby_mediawiki_88x31.png'
      ]

      url = 'http://en.wikipedia.org/wiki/Standard_test_image'

      client = described_class.new(url, include_css_images: false)

      expect(client.image_urls).to eq(images)
    end

    it 'scrapes with whitespace stripped' do
      file = 'spec/support/extra_whitespace.html'

      client = described_class.new('')
      client.doc = File.open(file) { |f| Nokogiri::HTML(f) }

      images = [
        'http://g-ecx.images-amazon.com/images/G/01/SIMON/IsaacsonWalter._V164348457_.jpg',
        'http://g-ecx.images-amazon.com/images/G/01/SIMON/IsaacsonWalter.jpg'
      ]

      expect(client.image_urls).to eq(images)
    end

    it 'scrapes relative paths' do
      scraper = described_class.new('http://en.wikipedia.org/wiki/Standard_test_image',
                                    convert_to_absolute_url: false,
                                    include_css_images: false)

      images = [
        '//upload.wikimedia.org/wikipedia/commons/thumb/b/b6/SIPI_Jelly_Beans_4.1.07.tiff/lossy-page1-220px-SIPI_Jelly_Beans_4.1.07.tiff.jpg',
        '//upload.wikimedia.org/wikipedia/en/thumb/5/5c/Symbol_template_class.svg/16px-Symbol_template_class.svg.png',
        '//upload.wikimedia.org/wikipedia/en/thumb/5/5c/Symbol_template_class.svg/16px-Symbol_template_class.svg.png',
        '//en.wikipedia.org/wiki/Special:CentralAutoLogin/start?type=1x1',
        '/static/images/wikimedia-button.png',
        '/static/images/poweredby_mediawiki_88x31.png'
      ]

      expect(scraper.image_urls).to eq(images)
    end
  end

  describe '#stylesheets' do
    it 'lists relative path stylesheets' do
      file = 'spec/support/stylesheet_test.html'

      client = described_class.new('')
      client.doc = File.open(file) { |f| Nokogiri::HTML(f) }
      client.url = 'http://test.com'

      stylesheets = [
        'http://test.com/css/master.css',
        'http://test.com/css/master2.css'
      ]

      expect(client.stylesheets).to eq(stylesheets)
    end

    it 'scrapes stylesheet images' do
      url = 'https://raw.github.com/charlotte-ruby/image_scraper/master/test/resources/stylesheet_unescaped_image.html'

      scraper = described_class.new(url, include_css_images: true)

      expect(scraper.stylesheet_images).to include('https://raw.github.com/charlotte-ruby/image_scraper/master/someimage.png')
    end
  end
end