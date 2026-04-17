CHECK_FILES := scss/* post/*.md eleventy.config.js package.json

build: fmt_check quarto_render _site

quarto_render:
	uv run quarto render quarto/llms-dont-understand-the-grain-of-your-data/index.qmd
	mv quarto/llms-dont-understand-the-grain-of-your-data/index.html post/llms-dont-understand-the-grain-of-your-data.html

_site:
	npm run build

dev:
	npm run start

deploy: _site
	uvx --from awscli aws s3 sync _site s3://${S3_BUCKET} --delete

fmt:
	npx prettier --write ${CHECK_FILES}
	panache format quarto/**/*.qmd

fmt_check:
	npx prettier --check ${CHECK_FILES}
	panache format --check quarto/**/*.qmd

content_check: _site
	python3 bin/check_content.py

link_check: _site
	python3 -m http.server --directory _site 8765 & \
	SERVER_PID=$$!; \
	sleep 1; \
	npx linkinator http://localhost:8765 --recurse --skip "^https?://(?!localhost)" --verbosity ERROR --retry-errors --retry-errors-count 3; \
	EXIT_CODE=$$?; \
	kill $$SERVER_PID 2>/dev/null; \
	exit $$EXIT_CODE

install-hooks:
	git config core.hooksPath .githooks

clean:
	rm -rf _site
