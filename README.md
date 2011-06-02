# image_scraper

Simple utility that pulls image URLS from web page

## INSTALL

Add to your gemfile

    gem "image_scraper"

Install w/ Bundler

    bundle install
    
## USAGE

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

