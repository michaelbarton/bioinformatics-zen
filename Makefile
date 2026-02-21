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
	python3 -m http.server --directory _site 8765 & \
	SERVER_PID=$$!; \
	sleep 1; \
	npx linkinator http://localhost:8765 --recurse --skip "^https?://(?!localhost)" --verbosity ERROR --retry-errors --retry-errors-count 3; \
	EXIT_CODE=$$?; \
	kill $$SERVER_PID 2>/dev/null; \
	exit $$EXIT_CODE

clean:
	rm -rf _site
