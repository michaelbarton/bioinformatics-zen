build: $(shell find source) $(fetch) Gemfile.lock
	bundle exec middleman build --verbose

dev: $(shell find source) $(fetch) Gemfile.lock
	bundle exec middleman server

########################################
#
# Bootstrap resources
#
########################################

bootstrap: Gemfile.lock

Gemfile.lock: Gemfile
	bundle install --path vendor/bundle

clean:
	rm -rf build

.PHONY: build dev bootstrap
