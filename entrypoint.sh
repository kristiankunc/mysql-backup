#!/bin/sh
crond

./app/entrypoint.sh

tail -f /dev/null