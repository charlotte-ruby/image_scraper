# frozen_string_literal: true

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  warn e.message
  warn 'Run `bundle install` to install missing gems'
  exit e.status_code
end

require 'rake'
require 'jeweler'
require 'rdoc/task'

Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = 'image_scraper'
  gem.homepage = 'http://github.com/charlotte-ruby/image_scraper'
  gem.license = 'MIT'
  gem.summary = %(Simple utility to pull image urls from web page)
  gem.description = %(Simple utility to pull image urls from web page)
  gem.email = 'john.mcaliley@gmail.com'
  gem.authors = ['John McAliley']
  gem.add_dependency 'nokogiri'
  gem.add_dependency 'css_parser'
  gem.files.exclude 'test/**/*'
  gem.required_ruby_version = '>= 2.6.9'
end

Jeweler::RubygemsDotOrgTasks.new

Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ''

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "image_scraper #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
