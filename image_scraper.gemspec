# frozen_string_literal: true

require_relative 'lib/image_scraper/version'

Gem::Specification.new do |spec|
  spec.name = 'image_scraper'
  spec.version = ImageScraper::VERSION
  spec.authors = ['John McAliley', 'Matt McMahand']
  spec.email = ['john.mcaliley@gmail.com', 'matt@invalid8.com']
  spec.summary = 'Simple utility to pull image urls from web page'
  spec.description = spec.summary
  spec.homepage = 'http://github.com/charlotte-ruby/image_scraper'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.6.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = File.join(spec.homepage, 'blob/master/CHANGELOG.md')

  spec.metadata['rubygems_mfa_required'] = 'true'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end

  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'css_parser', '~> 1.11'
  spec.add_dependency 'nokogiri', '~> 1.13'
end
