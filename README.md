# ImageScraper

![Ruby](https://github.com/charlotte-ruby/image_scraper/workflows/main/badge.svg)

Simple utility that pulls image URLs from web page
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'image_scraper'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install image_scraper

## Usage

Initialize the image scraper client

    image_scraper = ImageScraper::Client.new("http://www.rubygems.org")

You can also pass an options hash to the client when you initialize it:

    image_scraper = ImageScraper::Client.new("http://www.rubygems.org", options)
    # OPTIONS - If you don't pass the option, it will default to true
    # :convert_to_absolute_url - If there are relative image URLS, it will convert them to absolute URLS.
    # :include_css_images - If there are stylesheets on the page, it will pull images out of the stylesheet.  For example: background: url(/images/some-image.png).
    # :include_css_data_images - Will include data images from CSS.  For example: data:image/gif;base64,R0lGODlhEAAOALMAAOazToeH............

Get the images from the url specified when you initialized the client:

    image_scraper.image_urls

This will return an array of strings.
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`. Releases are done via Github Actions.

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

