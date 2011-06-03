module ImageScraper
  module Util
    def self.absolute_url(url,asset=nil)
      return url if asset.nil?
      return asset if asset.include?("://")
      return domain(url)+asset if asset[0]=="/"
      return domain(url) =~ /\/$/  ? domain(url)+asset : domain(url)+"/"+asset
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