require 'pp'
require 'helper'


#TODO: these tests will not work forever.  Try to test against a static web page instead of external URLs
# Consider using https://raw.github.com/charlotte-ruby/image_scraper urls

class TestImageScraper < Test::Unit::TestCase
  should "return list of all image urls on a web page with absolute paths" do
    images = ["http://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/SIPI_Jelly_Beans_4.1.07.tiff/lossy-page1-220px-SIPI_Jelly_Beans_4.1.07.tiff.jpg",
              "http://bits.wikimedia.org/static-1.21wmf5/skins/common/images/magnify-clip.png",
              "http://bits.wikimedia.org/static-1.21wmf5/skins/vector/images/search-ltr.png?303-4",
              "http://bits.wikimedia.org/images/wikimedia-button.png",
              "http://bits.wikimedia.org/static-1.21wmf5/skins/common/images/poweredby_mediawiki_88x31.png"]
    scraper = ImageScraper::Client.new("http://en.wikipedia.org/wiki/Standard_test_image",:include_css_images=>false)

    assert_equal images.size, scraper.image_urls.size

    assert_equal images, scraper.image_urls
  end

  should "return a list of images with whitespace stripped from the src" do
    client = ImageScraper::Client.new("http://www.google.com")
    html = IO.read(File.dirname(__FILE__)+"/resources/extra_whitespace.html")
    client.doc = Nokogiri::HTML(html)
    images = ["http://g-ecx.images-amazon.com/images/G/01/SIMON/IsaacsonWalter._V164348457_.jpg","http://g-ecx.images-amazon.com/images/G/01/SIMON/IsaacsonWalter.jpg"]
    
    assert_equal images, client.image_urls
  end

  should "return list of all image urls on a web page with relative paths" do
    images = ["//upload.wikimedia.org/wikipedia/commons/thumb/b/b6/SIPI_Jelly_Beans_4.1.07.tiff/lossy-page1-220px-SIPI_Jelly_Beans_4.1.07.tiff.jpg",
              "//bits.wikimedia.org/static-1.21wmf5/skins/common/images/magnify-clip.png",
              "//bits.wikimedia.org/static-1.21wmf5/skins/vector/images/search-ltr.png?303-4",
              "//bits.wikimedia.org/images/wikimedia-button.png",
              "//bits.wikimedia.org/static-1.21wmf5/skins/common/images/poweredby_mediawiki_88x31.png"]
    scraper = ImageScraper::Client.new("http://en.wikipedia.org/wiki/Standard_test_image",:convert_to_absolute_url=>false,:include_css_images=>false)
    
    assert_equal images.size, scraper.image_urls.size
    assert_equal images, scraper.image_urls
  end

  should "return list of stylesheets contained in html page (relative path)" do
    scraper = ImageScraper::Client.new ""
    scraper.doc = Nokogiri::HTML(IO.read(File.dirname(__FILE__)+"/resources/stylesheet_test.html"))
    scraper.url = "http://test.com"
    
    assert_equal ["http://test.com/css/master.css", "http://test.com/css/master2.css"], scraper.stylesheets
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
    scraper = ImageScraper::Client.new 'https://raw.github.com/charlotte-ruby/image_scraper/master/test/resources/stylesheet_unescaped_image.html', :include_css_images => true
    assert scraper.stylesheet_images.include? 'https://raw.github.com/charlotte-ruby/image_scraper/master/some%20image.png'
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

  should "Handle a URL with unescaped spaces" do
    images = ["https://raw.github.com/syoder/image_scraper/stylesheet_fix/test/resources/image1.png"]
    scraper = ImageScraper::Client.new 'https://raw.github.com/syoder/image_scraper/stylesheet_fix/test/resources/space in url.html', :include_css_images => false
    assert_equal images, scraper.image_urls
  end

  should "Handle a page image with an unescaped url" do
    scraper = ImageScraper::Client.new ''
    scraper.doc = Nokogiri::HTML("<img src='http://test.com/unescaped path'>")
    assert_equal ['http://test.com/unescaped%20path'], scraper.page_images
  end

  should "Handle a stylesheet with an unescaped url" do
    scraper = ImageScraper::Client.new ''
    scraper.url = 'http://test.com'
    scraper.doc = Nokogiri::HTML("<link rel='stylesheet' href='http://test.com/unescaped path.css'>")
    assert_equal ['http://test.com/unescaped%20path.css'], scraper.stylesheets
  end

  should "Handle a stylesheet image with an unescaped url" do
    scraper = ImageScraper::Client.new 'https://raw.github.com/charlotte-ruby/image_scraper/master/test/resources/stylesheet_unescaped_image.html', :include_css_images => true
    assert_equal ['https://raw.github.com/charlotte-ruby/image_scraper/master/some%20image.png'], scraper.stylesheet_images
  end

  should "Handle a stylesheet image with a relative url" do
    scraper = ImageScraper::Client.new 'https://raw.github.com/charlotte-ruby/image_scraper/master/test/resources/relative_image_url.html', :include_css_images => true
    assert_equal ['https://raw.github.com/charlotte-ruby/image_scraper/master/test/images/some_image.png'], scraper.stylesheet_images
  end

  should "Handle cases where a stylesheet returns a 404" do
    scraper = ImageScraper::Client.new ''
    scraper.url = 'http://google.com'
    scraper.doc = Nokogiri::HTML("<link rel='stylesheet' href='http://google.com/does_not_exist.css'>")
    assert_equal [], scraper.stylesheet_images
  end
end
