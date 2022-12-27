FROM ruby:3.2-alpine

WORKDIR /usr/src/app

RUN apk update && \
	apk add gcc gcompat git \
	libxml2-dev libxslt-dev \
	make musl-dev

RUN mkdir -p lib/image_scraper
COPY lib/image_scraper/version.rb ./lib/image_scraper/version.rb
COPY .ruby-version image_scraper.gemspec Gemfile Gemfile.lock ./

RUN bundle install
COPY . .
