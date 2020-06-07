# frozen_string_literal: true

require 'pp'
require 'helper'
require 'pry'

# TODO: these tests will not work forever.  Try to test against a static web page instead of external URLs
# Consider using https://raw.github.com/charlotte-ruby/image_scraper urls

class TestImageScraper < Test::Unit::TestCase

  should 'Handle a URL with unescaped spaces' do
    images = ['https://raw.github.com/syoder/image_scraper/stylesheet_fix/test/resources/image1.png']
    scraper = ImageScraper::Client.new 'https://raw.github.com/syoder/image_scraper/stylesheet_fix/test/resources/space in url.html', include_css_images: false
    assert_equal images, scraper.image_urls
  end

  should 'Handle a page image with an unescaped url' do
    scraper = ImageScraper::Client.new ''
    scraper.doc = Nokogiri::HTML("<img src='http://test.com/unescaped path'>")
    assert_equal ['http://test.com/unescaped%20path'], scraper.page_images
  end

  should 'Handle a stylesheet with an unescaped url' do
    scraper = ImageScraper::Client.new ''
    scraper.url = 'http://test.com'
    scraper.doc = Nokogiri::HTML("<link rel='stylesheet' href='http://test.com/unescaped path.css'>")

    assert_equal ['http://test.com/unescapedpath.css'], scraper.stylesheets
  end

  should 'Handle a stylesheet image with an unescaped url' do
    scraper = ImageScraper::Client.new 'https://raw.github.com/charlotte-ruby/image_scraper/master/test/resources/stylesheet_unescaped_image.html', include_css_images: true

    assert_equal ['https://raw.github.com/charlotte-ruby/image_scraper/master/someimage.png'], scraper.stylesheet_images
  end

  should 'Handle a stylesheet image with a relative url' do
    scraper = ImageScraper::Client.new 'https://raw.github.com/charlotte-ruby/image_scraper/master/test/resources/relative_image_url.html', include_css_images: true
    assert_equal ['https://raw.github.com/charlotte-ruby/image_scraper/master/test/images/some_image.png'], scraper.stylesheet_images
  end

  should 'Handle cases where a stylesheet returns a 404' do
    scraper = ImageScraper::Client.new ''
    scraper.url = 'http://google.com'
    scraper.doc = Nokogiri::HTML("<link rel='stylesheet' href='http://google.com/does_not_exist.css'>")
    assert_equal [], scraper.stylesheet_images
  end

  should 'not crash when it encounters image URLs that include square brackets' do
    scraper = ImageScraper::Client.new ''
    scraper.url = 'http://google.com'
    scraper.doc = Nokogiri::HTML("<img src='image[1].jpg' >")

    assert_equal [], scraper.page_images
  end
end
