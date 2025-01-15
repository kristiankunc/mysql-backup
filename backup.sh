#!/bin/bash

echo "Starting backup..."

DATE=$(date +"%d-%m-%Y")

FILENAME_PATH="/tmp/mysql_bacup/backup_$DATE.sql"

mkdir -p "$(dirname "$FILENAME_PATH")"
mysqldump -h $MYSQL_HOST -P 3306 -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE > $FILENAME_PATH

echo "MySQL dump completed"

gsutil cp $FILENAME_PATH gs://$BACKUP_BUCKET/$DATE.sql

echo "Dump uploaded"

gsutil ls gs://$BACKUP_BUCKET/ | while read -r file; do
    file_date=$(echo "$file" | grep -o '[0-9]\{2\}-[0-9]\{2\}-[0-9]\{4\}')
    if [ ! -z "$file_date" ]; then
        file_timestamp=$(date -d "$(echo ${file_date} | sed 's/\([0-9]\{2\}\)-\([0-9]\{2\}\)-\([0-9]\{4\}\)/\2/\1/\3/')" +%s)
        current_timestamp=$(date +%s)
        age_days=$(( (current_timestamp - file_timestamp) / 86400 ))
        if [ $age_days -gt $BACKUP_RETENTION_DAYS ]; then
            gsutil rm "$file"
            echo "Deleted $file, $age_days days old"
        fi
    fi
done

rm $FILENAME_PATH