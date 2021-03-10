.PHONY: build
build:
	@./docker/build.sh

.PHONY: upgrade
upgrade:
	@./docker/build.sh --pull --no-cache
