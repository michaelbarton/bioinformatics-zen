credentials = .aws_credentials

publish: build
	s3cmd sync \
		--config $(credentials) \
		--delete-removed \
		--acl-public \
		$</* s3://www.bioinformaticszen.com/

build: Gemfile.lock
	bundle exec nanoc compile

dev: Gemfile.lock
	bundle exec nanoc watch

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
