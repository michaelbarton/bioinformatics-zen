FROM ruby:3.1
RUN apt-get update && apt-get install --yes nodejs
ADD Gemfile .
RUN bundle install

