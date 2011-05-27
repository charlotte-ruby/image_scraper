# image_scraper

Simple utility that pulls image URLS from web page

## INSTALL

Add to your gemfile

    gem "image_scraper"

Install w/ Bundler

    bundle install
    
## USAGE

Pull all the image URLs from a specified URL and convert all images URLs to absolute paths

    ImageScraper.image_urls("http://www.rubygems.org")

Pull all images URLs from specified URL and use relative URLs

    ImageScraper.image_urls("http://www.rubygems.org",false)

## TODO

1. Parse CSS files for images

## Contributing to image_scraper
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011 John McAliley. See LICENSE.txt for
further details.

