FROM ruby:3.0
ADD Gemfile .
RUN bundler install
ENTRYPOINT ['middleman']
