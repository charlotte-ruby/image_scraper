require 'pp'
require 'helper'


#TODO: these tests will not work forever.  Try to test against a static web page instead of external URLs
class TestImageScraper < Test::Unit::TestCase
  should "return list of all image urls on a web page with absolute paths" do
    images = ["http://en.wikipedia.org//bits.wikimedia.org/skins-1.18/vector/images/search-ltr.png?303-4",
     "http://en.wikipedia.org//bits.wikimedia.org/images/wikimedia-button.png",
     "http://en.wikipedia.org//bits.wikimedia.org/skins-1.18/common/images/poweredby_mediawiki_88x31.png"]
    scraper = ImageScraper::Client.new("http://en.wikipedia.org/wiki/Standard_test_image",:include_css_images=>false)
    assert_equal images, scraper.image_urls
  end

  should "return list of all image urls on a web page with relative paths" do
    images = ["//bits.wikimedia.org/skins-1.18/vector/images/search-ltr.png?303-4",
     "//bits.wikimedia.org/images/wikimedia-button.png",
     "//bits.wikimedia.org/skins-1.18/common/images/poweredby_mediawiki_88x31.png"]
    scraper = ImageScraper::Client.new("http://en.wikipedia.org/wiki/Standard_test_image",:convert_to_absolute_url=>false,:include_css_images=>false)
    assert_equal images, scraper.image_urls
  end

  should "return list of stylesheets contained in html page (relative path)" do
    doc = Nokogiri::HTML(IO.read(File.dirname(__FILE__)+"/resources/stylesheet_test.html"))
    domain = "http://test.com"
    assert_equal ["http://test.com/phoenix/testcentral.css","http://test.com/engine1/style.css"], ImageScraper::Client.new("http://test.com").stylesheets
  end
  
  should "return proper absolute url for a page and asset" do
    assert_equal "http://www.test.com/image.gif", ImageScraper::Util.absolute_url("http://www.test.com","image.gif")
    assert_equal "http://www.test.com/images/image.gif",ImageScraper::Util.absolute_url("http://www.test.com","images/image.gif")
    assert_equal "http://www.test.com/images/image.gif",ImageScraper::Util.absolute_url("http://www.test.com","/images/image.gif")
    assert_equal "http://www.test.com/image.gif", ImageScraper::Util.absolute_url("http://www.test.com/","image.gif")
    assert_equal "http://www.test.com/images/image.gif", ImageScraper::Util.absolute_url("http://www.test.com/","/images/image.gif")
    assert_equal "http://www.test.com/images/image.gif", ImageScraper::Util.absolute_url("http://www.test.com/","images/image.gif")
    assert_equal "http://www.test.com/images/image.gif", ImageScraper::Util.absolute_url("http://www.test.com/","/images/image.gif")
    assert_equal "http://www.test.com/", ImageScraper::Util.absolute_url("http://www.test.com/")
    assert_equal "http://www.test.com/123/test.html", ImageScraper::Util.absolute_url("http://www.test.com/123/test.html")
  end
  
  should "return images from a stylesheet" do
    scraper = ImageScraper::Client.new("http://couponshack.com")
    assert scraper.stylesheet_images.include? ("http://couponshack.com/images/bg.jpg")
  end
  
  should "strip quotes from a url" do
    assert_equal "/images/test.png", ImageScraper::Util.strip_quotes("'/images/test.png'")
    assert_equal "http://www.somsite.com/images/test.png", ImageScraper::Util.strip_quotes("'http://www.somsite.com/images/test.png'")
    assert_equal "/images/test.png", ImageScraper::Util.strip_quotes('"/images/test.png"')
  end
  
  should "return domain section from a url" do
    assert_equal "http://ug.ly", ImageScraper::Util.domain("http://ug.ly/what/is/this.html")
    assert_equal "http://ug.ly", ImageScraper::Util.domain("http://ug.ly/what/is/this/")
    assert_equal "http://ug.ly", ImageScraper::Util.domain("http://ug.ly/what")
    assert_equal "http://www.ug.ly", ImageScraper::Util.domain("http://www.ug.ly/what/is/this/")
  end
  
  should "return nil for doc if URL is invalid" do
    scraper = ImageScraper::Client.new("couponshack.com")
    assert scraper.doc.nil?
  end
  
  should "return empty arrays if URL is invalid" do
    scraper = ImageScraper::Client.new("couponshack.com")
    assert_equal [], scraper.image_urls
    assert_equal [], scraper.stylesheets
    assert_equal [], scraper.stylesheet_images
    assert_equal [], scraper.page_images
  end
end