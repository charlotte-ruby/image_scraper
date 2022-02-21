# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'

require_relative 'image_scraper/client'
require_relative 'image_scraper/railtie' if defined?(Rails::Railtie)
require_relative 'image_scraper/util'
require_relative 'image_scraper/version'

module ImageScraper
  class Error < StandardError; end
end
