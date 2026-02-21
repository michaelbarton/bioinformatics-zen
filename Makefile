CHECK_FILES := scss/* post/*.md eleventy.config.js package.json

build: fmt_check _site

_site:
	npm run build

dev:
	npm run start

deploy: _site
	uvx --from awscli aws s3 sync _site s3://${S3_BUCKET} --delete

fmt:
	npx prettier --write ${CHECK_FILES}

fmt_check:
	npx prettier --check ${CHECK_FILES}

link_check: _site
	npx linkinator ./_site --recurse --skip "^https?://" --verbosity ERROR

clean:
	rm -rf _site
