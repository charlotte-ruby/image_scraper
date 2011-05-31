require 'pp'
require 'helper'

class TestImageScraper < Test::Unit::TestCase
  should "return list of all image urls on a web page with absolute paths" do
    images = ["http://upload.wikimedia.org/wikipedia/en/thumb/2/24/Lenna.png/200px-Lenna.png", "http://bits.wikimedia.org/skins-1.17/common/images/magnify-clip.png", "http://bits.wikimedia.org/skins-1.17/vector/images/search-ltr.png?301-2", "http://en.wikipedia.org/images/wikimedia-button.png", "http://bits.wikimedia.org/skins-1.17/common/images/poweredby_mediawiki_88x31.png"]
    assert_equal images, ImageScraper.image_urls("http://en.wikipedia.org/wiki/Standard_test_image")
  end
  
  should "return list of all image urls on a web page with relative paths" do
    images = ["http://upload.wikimedia.org/wikipedia/en/thumb/2/24/Lenna.png/200px-Lenna.png","http://bits.wikimedia.org/skins-1.17/common/images/magnify-clip.png","http://bits.wikimedia.org/skins-1.17/vector/images/search-ltr.png?301-2","/images/wikimedia-button.png","http://bits.wikimedia.org/skins-1.17/common/images/poweredby_mediawiki_88x31.png"]
    assert_equal images, ImageScraper.image_urls("http://en.wikipedia.org/wiki/Standard_test_image",:convert_to_absolute_url=>false)
  end
  
  should "return list of stylesheets contained in html page" do
    doc = Nokogiri::HTML(open "http://www.twitter.com")
    p ImageScraper.find_stylesheets(doc)
  end
end