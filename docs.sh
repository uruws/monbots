#!/bin/sh
set -eu
exec docker run -it --rm -u uws \
	uws/uwsbot-devel /usr/bin/less /uws/share/doc/uwsbot/docs.txt
