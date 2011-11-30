module ImageScraper
  module Util
    def self.absolute_url(url,asset=nil)
      # TODO - what happens when an index redirect occurs?
      # Example: 'http://example.com/about' specified as url
      #          'style.css' specified as asset
      #          url redirects to 'http://example.com/about/'
      #          and serves http://example.com/about/index.html
      #          which then links to the relative asset path 'style.css'
      #          based on original url (http://example.com/about), 
      #          self.absolute_url gives
      #          'http://example.com/style.css
      #          but should get:
      #          'http://example.com/about/style.css
      URI.parse(url).merge(URI.parse asset.to_s).to_s
    end
    
    def self.domain(url)
      uri = URI.parse(url)
      "#{uri.scheme}://#{uri.host}"
    end
    
    def self.path(url)
      uri = URI.parse(url)
      uri.path
    end
    
    def self.strip_quotes(image_url)
      image_url.gsub("'","").gsub('"','')
    end
  end
end
