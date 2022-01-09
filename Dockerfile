FROM ruby:3.1
ADD Gemfile .
RUN bundle install

