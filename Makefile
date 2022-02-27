export COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1

build: image
	docker-compose run --rm runner npm run build

dev: image
	 docker-compose up --remove-orphans

shell: image
	docker-compose run --rm runner /bin/bash

fmt: image
	docker-compose run --rm runner prettier --write scss/* post/* .eleventy.js

image: Dockerfile package.json
	docker-compose build runner
