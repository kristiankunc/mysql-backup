FROM google/cloud-sdk:alpine

RUN apk update && apk upgrade && \
    apk add --no-cache dcron && \
    mkdir -p /app

COPY backup.sh /app/backup.sh
RUN chmod +x /app/backup.sh

COPY start.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

COPY crontab /etc/cron.d/backup-cron
RUN chmod 0644 /etc/cron.d/backup-cron && \
    crontab /etc/cron.d/backup-cron

CMD ["/app/entrypoint.sh"]