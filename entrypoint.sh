#!/bin/sh
/usr/sbin/crond -f -l 2 &

gcloud auth activate-service-account --key-file=$BACKUP_CREDENTIALS_PATH
gcloud config set project $BACKUP_PROJECT_ID
gcloud auth login

./app/backup.sh

exec tail -f /var/log/cron.log /var/log/syslog 2>/dev/null || true