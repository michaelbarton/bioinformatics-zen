publish: build Gemfile.lock 
	bundle exec middleman s3_sync

test: build Gemfile.lock 
	bundle exec ./plumbing/check-forbidden-words forbidden_words.txt $(shell ls build/post/*/index.html)
	bundle exec htmlproof --disable-external --check-html --href-ignore '#' $<

build: Gemfile.lock
	bundle exec middleman build --verbose
	touch $@

dev: Gemfile.lock
	bundle exec middleman server


########################################
#
# Bootstrap resources
#
########################################

bootstrap: Gemfile.lock \
	vendor/bootstrap \
	vendor/stylesheets \
	vendor/javascripts/ekko-lightbox.min.js \
	vendor/javascripts/bootstrap.min.js

Gemfile.lock: Gemfile
	bundle install --path vendor/bundle

vendor/stylesheets:
	mkdir -p $@
	wget \
		--quiet \
		--output-document $@/ekko-lightbox.min.css \
		https://raw.githubusercontent.com/ashleydw/lightbox/master/dist/ekko-lightbox.min.css
	touch $@

vendor/javascripts/bootstrap.min.js:
	mkdir -p $(dir $@)
	cp ./vendor/bootstrap/dist/js/bootstrap.min.js $@

vendor/javascripts/ekko-lightbox.min.js:
	mkdir -p $(dir $@)
	wget \
		--quiet \
		--output-document $@ \
		https://raw.githubusercontent.com/ashleydw/lightbox/master/dist/ekko-lightbox.min.js
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
	  https://github.com/fancyapps/fancyBox/zipball/v2.1.5
	unzip fancybox.zip
	mv fancyapps-fancyBox-* $@
	rm fancybox.zip
	touch $@

clean:
	rm -rf build

.PHONY: build dev bootstrap
