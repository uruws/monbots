#!/bin/sh
set -eu
exec ./docker/run.sh api "$@"
