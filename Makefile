CHECK_FILES := scss/* post/*.md eleventy.config.js package.json
SLUGS := $(notdir $(patsubst %/,%,$(dir $(wildcard quarto/*/index.qmd))))

build: fmt_check quarto_render _site

data:
	for d in quarto/*/Makefile; do $(MAKE) -C $$(dirname $$d) || exit 1; done

quarto_render: data
	cd quarto && uv run quarto render

_site:
	npm run build

dev:
	npm run start

preview: data
	npm run start & \
	SERVER_PID=$$!; \
	cd quarto && uv run quarto preview --no-serve --no-browser; \
	kill $$SERVER_PID 2>/dev/null

deploy:
	uvx --from awscli aws s3 sync _site s3://${S3_BUCKET} --delete --cache-control "public, max-age=300"

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
	rm -f $(addprefix post/,$(addsuffix .html,$(SLUGS)))
	rm -rf $(addprefix assets/posts/,$(SLUGS))
