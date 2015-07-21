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

bootstrap: Gemfile.lock vendor/bootstrap vendor/fancybox vendor/javascripts

Gemfile.lock: Gemfile
	bundle install --path vendor/bundle

vendor/javascripts: vendor/fancybox
	mkdir -p $@
	cp ./vendor/fancybox/fancybox/jquery.fancybox-1.3.4.pack.js $@/fancybox.min.js
	touch $@

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

vendor/fancybox:
	mkdir -p vendor
	wget \
	  --quiet \
	  --output-document fancybox.zip \
	  http://fancybox.googlecode.com/files/jquery.fancybox-1.3.4.zip
	unzip fancybox.zip
	mv jquery.fancybox-1.3.4 $@
	rm fancybox.zip
	touch $@

clean:
	rm -rf build

.PHONY: build dev bootstrap
