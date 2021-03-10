#!/bin/sh
set -eu
UWS_LOG=${UWS_LOG:-'default'}
BOT=${1:?'bot name?'}
SCRIPT=${2:-''}
ARGS=''
if test 'X' != "X${SCRIPT}"; then
	ARGS="-run ${SCRIPT}"
fi
exec docker run -it --rm --name uws-bot-devel \
	--hostname bot-devel.uws.local \
	-e UWSENV=bot/staging \
	-e "UWS_LOG=${UWS_LOG}" \
	-v "${PWD}:/uws/share/uwsbot:ro" \
	-v "${PWD}/docker/auth:/home/uws/.config/uws/bot:ro" \
	-u uws uws/uwsbot-devel /uws/bin/uwsbot -env staging -name ${BOT} ${ARGS}
