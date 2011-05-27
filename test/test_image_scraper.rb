require 'helper'

class TestImageScraper < Test::Unit::TestCase
  should "return list of all image urls on a web page with absolute paths" do
    images = ["http://upload.wikimedia.org/wikipedia/en/thumb/2/24/Lenna.png/200px-Lenna.png", "http://bits.wikimedia.org/skins-1.17/common/images/magnify-clip.png", "http://bits.wikimedia.org/skins-1.17/vector/images/search-ltr.png?301-2", "http://en.wikipedia.org/images/wikimedia-button.png", "http://bits.wikimedia.org/skins-1.17/common/images/poweredby_mediawiki_88x31.png"]
    assert_equal ImageScraper.image_urls("http://en.wikipedia.org/wiki/Standard_test_image"), images
  end
  
  should "return list of all image urls on a web page with relative paths" do
    images = ["http://upload.wikimedia.org/wikipedia/en/thumb/2/24/Lenna.png/200px-Lenna.png","http://bits.wikimedia.org/skins-1.17/common/images/magnify-clip.png","http://bits.wikimedia.org/skins-1.17/vector/images/search-ltr.png?301-2","/images/wikimedia-button.png","http://bits.wikimedia.org/skins-1.17/common/images/poweredby_mediawiki_88x31.png"]
    assert_equal ImageScraper.image_urls("http://en.wikipedia.org/wiki/Standard_test_image",false), images
  end  
end
