#!/bin/sh
set -e

/usr/sbin/crond -f -l 8 &

./app/entrypoint.sh &

exec tail -f /var/log/cron.log /var/log/syslog 2>/dev/null || true