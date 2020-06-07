# frozen_string_literal: true

require 'spec_helper'
require 'image_scraper'

describe ImageScraper::Util do

  describe 'absolute_url' do
    it 'parses asset' do
      url = 'http://www.test.com'
      asset = 'image.gif'

      result = described_class.absolute_url(url, asset)

      expect(result).to eq('http://www.test.com/image.gif')
    end

    it 'parses relative asset' do
      url = 'http://www.test.com'
      asset = 'images/image.gif'

      result = described_class.absolute_url(url, asset)

      expect(result).to eq('http://www.test.com/images/image.gif')
    end

    it 'parses absolute asset' do
      url = 'http://www.test.com'
      asset = '/images/image.gif'

      result = described_class.absolute_url(url, asset)

      expect(result).to eq('http://www.test.com/images/image.gif')
    end

    it 'parses root url with no asset' do
      result = described_class.absolute_url('http://www.test.com')

      expect(result).to eq('http://www.test.com')
    end

    it 'parses url with no asset' do
      result = described_class.absolute_url('http://www.test.com/a/test.html')

      expect(result).to eq('http://www.test.com/a/test.html')
    end
  end

  describe 'strip_quotes' do
    it 'parses paths' do
      result = described_class.strip_quotes("'/images/test.png'")

      expect(result).to eq('/images/test.png')
    end

    it 'parses a full url' do
      str = "'http://www.somsite.com/images/test.png'"

      result = described_class.strip_quotes(str)

      expect(result).to eq('http://www.somsite.com/images/test.png')
    end

    it 'parses emptyness' do
      result = described_class.strip_quotes('')

      expect(result).to be_empty
    end
  end

  describe 'domain' do
    it 'parses the domain of a url' do
      u = described_class

      expect(u.domain('http://ug.ly')).to eq('http://ug.ly')
      expect(u.domain('http://ug.ly/what')).to eq('http://ug.ly')
      expect(u.domain('http://ug.ly/what/is/this/')).to eq('http://ug.ly')
      expect(u.domain('http://www.ug.ly/what/is/this/')).to eq('http://www.ug.ly')
      expect(u.domain('http://ug.ly/what/is/this.html')).to eq('http://ug.ly')
    end
  end
end
