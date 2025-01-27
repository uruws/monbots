#!/bin/sh
set -eu
exec docker build $@ --rm -t uws/uwsbot-devel \
	--build-arg UWS_UID=$(id -u) \
	--build-arg UWS_GID=$(id -g) \
	--build-arg UWS_UMASK=$(umask) \
	./docker
