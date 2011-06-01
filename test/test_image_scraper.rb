require 'pp'
require 'helper'


#TODO: these tests will not work forever.  Try to test against a static web page instead of external URLs
class TestImageScraper < Test::Unit::TestCase
  should "return list of all image urls on a web page with absolute paths" do
    images = ["http://upload.wikimedia.org/wikipedia/en/thumb/2/24/Lenna.png/200px-Lenna.png",
     "http://bits.wikimedia.org/skins-1.17/common/images/magnify-clip.png",
     "http://bits.wikimedia.org/skins-1.17/vector/images/search-ltr.png?301-2",
     "http://en.wikipedia.org/images/wikimedia-button.png",
     "http://bits.wikimedia.org/skins-1.17/common/images/poweredby_mediawiki_88x31.png"]
    scraper = ImageScraper::Client.new("http://en.wikipedia.org/wiki/Standard_test_image",:include_css_images=>false)
    assert_equal images, scraper.image_urls
  end

  should "return list of all image urls on a web page with relative paths" do
    images = ["http://upload.wikimedia.org/wikipedia/en/thumb/2/24/Lenna.png/200px-Lenna.png",
     "http://bits.wikimedia.org/skins-1.17/common/images/magnify-clip.png",
     "http://bits.wikimedia.org/skins-1.17/vector/images/search-ltr.png?301-2",
     "/images/wikimedia-button.png",
     "http://bits.wikimedia.org/skins-1.17/common/images/poweredby_mediawiki_88x31.png"]
    scraper = ImageScraper::Client.new("http://en.wikipedia.org/wiki/Standard_test_image",:convert_to_absolute_url=>false,:include_css_images=>false)
    assert_equal images, scraper.image_urls
  end

  should "return list of stylesheets contained in html page (relative path)" do
    doc = Nokogiri::HTML(IO.read(File.dirname(__FILE__)+"/resources/stylesheet_test.html"))
    domain = "http://test.com"
    assert_equal ["http://test.com/phoenix/testcentral.css"], ImageScraper::Client.new("http://test.com").stylesheets
  end
  
  should "return proper absolute url for a page and asset" do
    assert_equal "http://www.test.com/image.gif", ImageScraper::Util.absolute_url("http://www.test.com","image.gif")
    assert_equal "http://www.test.com/images/image.gif",ImageScraper::Util.absolute_url("http://www.test.com","images/image.gif")
    assert_equal "http://www.test.com/images/image.gif",ImageScraper::Util.absolute_url("http://www.test.com","/images/image.gif")
    assert_equal "http://www.test.com/image.gif", ImageScraper::Util.absolute_url("http://www.test.com/","image.gif")
    assert_equal "http://www.test.com/images/image.gif", ImageScraper::Util.absolute_url("http://www.test.com/","/images/image.gif")
    assert_equal "http://www.test.com/images/image.gif", ImageScraper::Util.absolute_url("http://www.test.com/","images/image.gif")
    assert_equal "http://www.test.com/images/image.gif", ImageScraper::Util.absolute_url("http://www.test.com/","/images/image.gif")
  end
  
  should "return images from a stylesheet" do
    scraper = ImageScraper::Client.new("http://local.couponshack.com")
    assert scraper.stylesheet_images.include? ("http://local.couponshack.com/images/bg.png")
  end
end