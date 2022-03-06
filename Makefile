export COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1

CHECK_FILES := scss/* post/* .eleventy.js docker-compose.yml package.json

build: image
	docker-compose run --rm runner npm run build

dev: image
	 docker-compose up --remove-orphans

shell: image
	docker-compose run --rm runner /bin/bash

fmt: image
	docker-compose run --rm runner npx prettier --write ${CHECK_FILES}

fmt_check: image
	docker-compose run --rm runner npx prettier --check ${CHECK_FILES}

image: Dockerfile package.json package-lock.json
	docker-compose build runner
