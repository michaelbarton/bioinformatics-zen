test: build Gemfile.lock 
	  bundle exec htmlproof --check-html --href-ignore '#' $<

build: Gemfile.lock
	bundle exec middleman build --verbose

dev: Gemfile.lock
	bundle exec middleman server


########################################
#
# Bootstrap resources
#
########################################

bootstrap: Gemfile.lock vendor/bootstrap

Gemfile.lock: Gemfile
	bundle install --path vendor/bundle

vendor/bootstrap:
	mkdir -p vendor
	wget \
	  --quiet \
	  --output-document bootstrap.zip \
	  https://github.com/twbs/bootstrap/archive/v3.3.4.zip
	unzip bootstrap.zip
	mv bootstrap-3.3.4 $@
	rm bootstrap.zip
	touch $@

clean:
	rm -rf build

.PHONY: build dev bootstrap
