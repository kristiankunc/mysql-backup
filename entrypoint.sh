#!/bin/sh
/usr/sbin/crond -f -l 2 &

./app/backup.sh

exec tail -f /var/log/cron.log /var/log/syslog 2>/dev/null || true