# frozen_string_literal: true

require 'spec_helper'
require 'image_scraper'

describe ImageScraper::Client do
  let(:repo_url) { "https://raw.github.com/charlotte-ruby/image_scraper" }

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

    it 'handles url with unescaped spaces' do
      url = 'https://raw.github.com/syoder/image_scraper/stylesheet_fix/test/resources/space in url.html'

      scraper = described_class.new(url, include_css_images: false)

      expected_url = 'https://raw.github.com/syoder/image_scraper/stylesheet_fix/test/resources/image1.png'

      expect(scraper.image_urls.length).to eq(1)
      expect(scraper.image_urls.first).to eq(expected_url)
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

    it 'handles stylesheet with an unescaped url' do
      scraper = described_class.new('')
      scraper.url = 'http://test.com'
      scraper.doc = Nokogiri::HTML("<link rel='stylesheet' href='http://test.com/unescaped path.css'>")

      expect(scraper.stylesheets).to include('http://test.com/unescapedpath.css')
    end
  end

  describe '#page_images' do
    it 'handles unescaped urls' do
      scraper = described_class.new('')
      scraper.doc = Nokogiri::HTML("<img src='http://test.com/unescaped path'>")

      expect(scraper.page_images.length).to eq(1)
      expect(scraper.page_images).to include('http://test.com/unescaped%20path')
    end

    it 'handldes image urls that include square brackets' do
      scraper = described_class.new('')
      scraper.url = 'http://google.com'
      scraper.doc = Nokogiri::HTML("<img src='image[1].jpg' >")

      expect(scraper.page_images).to be_empty
    end
  end

  describe '#stylesheet_images' do
    it 'scrapes stylesheet images' do
      url = "#{repo_url}/master/test/resources/stylesheet_unescaped_image.html"
      stylesheet_path = "#{repo_url}/master/someimage.png"

      scraper = described_class.new(url, include_css_images: true)

      expect(scraper.stylesheet_images).to include(stylesheet_path)
    end

    it 'handles 404s' do
      scraper = described_class.new('')
      scraper.url = 'http://google.com'
      scraper.doc = Nokogiri::HTML("<link rel='stylesheet' href='http://google.com/does_not_exist.css'>")

      expect(scraper.stylesheet_images).to be_empty
    end

    it 'handles stylesheet image with a relative url' do
      url = "#{repo_url}/master/test/resources/relative_image_url.html"
      image_url = "#{repo_url}/master/test/images/some_image.png"

      scraper = described_class.new(url, include_css_images: true)

      expect(scraper.stylesheet_images).to include(image_url)
    end
  end
end
