# frozen_string_literal: true

source 'http://rubygems.org'

ruby File.read('.ruby-version').chomp

gemspec

gem 'rake', '~> 13.0'
gem 'rspec', '~> 3.4'
gem 'rubocop', '~> 1.21'

group :development do
  gem 'bundler', '~> 2.3'
  gem 'guard-rspec', require: false
  gem 'pry'
  gem 'rubocop-rspec', require: false
  gem 'test-unit'
  gem 'vcr', '~> 6.0'
  gem 'webmock'
end
