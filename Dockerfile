FROM google/cloud-sdk:alpine

RUN apk update && apk upgrade && \
    apk add --no-cache dcron rsyslog && \
    mkdir -p /app /var/log/cron

COPY backup.sh /app/backup.sh
RUN chmod +x /app/backup.sh

COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

COPY crontab /etc/cron.d/backup-cron
RUN chmod 0644 /etc/cron.d/backup-cron && \
    crontab /etc/cron.d/backup-cron

# Enable cron logging
RUN touch /var/log/cron.log

CMD ["/app/entrypoint.sh"]