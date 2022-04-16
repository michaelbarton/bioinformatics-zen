export COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1

CHECK_FILES := scss/* post/* .eleventy.js docker-compose.yml package.json

build: _site

_site: image
	docker-compose run --rm runner npm run build

dev: image
	 docker-compose up --remove-orphans

deploy: # _site
	docker-compose --env-file=.env run --rm deploy

shell: image
	docker-compose --env-file=.env run --rm runner /bin/bash

shell_deploy: # _site
	docker-compose --env-file=.env run --rm deploy /bin/bash

fmt: image
	docker-compose run --rm runner npx prettier --write ${CHECK_FILES}

fmt_check: image
	docker-compose run --rm runner npx prettier --check ${CHECK_FILES}

image: Dockerfile package.json package-lock.json
	docker-compose build runner

clean:
	rm -rf _site css
