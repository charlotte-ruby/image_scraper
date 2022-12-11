# ImageScraper
[![ruby](https://github.com/charlotte-ruby/image_scraper/actions/workflows/ruby.yml/badge.svg)](https://github.com/charlotte-ruby/image_scraper/actions/workflows/ruby.yml)

Simple utility that pulls image URLs from web page
## Installation

Install in your application's Gemfile or as a standalone gem:

```ruby
gem 'image_scraper'
```

And then execute:

```
$ bundle install
```

Standalone install:

```
$ gem install image_scraper
```

## Usage

```ruby
options = {
    convert_to_absolute_url: true,
    include_css_images: true # convert any relative images to absolute urls.
    include_css_data_images: true # convert any data images (data:image/gif;base64....)
}

image_scraper = ImageScraper::Client.new("http://www.rubygems.org", options)
image_scraper.image_urls

# => ["https://rubygems.org/assets/github_icon.png"", "https://rubygems.org/sponsors.png"]
```

### CLI

```
$ image_scraper https://unsplash.com | head -n 2
https://images.unsplash.com/photo-1471897488648
https://images.unsplash.com/photo-1590073242678
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`. Releases are done via Github Actions.

If you prefer to use docker:

```
docker-compose build
docker-compose run app
```

Once inside the container, run the tests and you'll see output similar to this:

```
/usr/src/app # bundle exec rspec
........................

Finished in 0.54303 seconds (files took 0.95976 seconds to load)
24 examples, 0 failures
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/charlotte-ruby/image_scraper. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/charlotte-ruby/image_scraper/blob/master/CODE_OF_CONDUCT.md).

- Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
- Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
- Fork the project
- Start a feature/bugfix branch
- Commit and push until you are happy with your contribution
- Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
- Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011 John McAliley. See LICENSE.txt for
further details.

## Code of Conduct

Everyone interacting in the ImageScraper project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/charlotte-ruby/image_scraper/blob/master/CODE_OF_CONDUCT.md).
