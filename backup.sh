#!/bin/bash

echo "Starting backup..."

DATE=$(date +"%d-%m-%Y")

FILENAME_PATH="/tmp/mysql_bacup/backup_$DATE.sql"

mkdir -p "$(dirname "$FILENAME_PATH")"
mysqldump --no-tablespaces -h $MYSQL_HOST -P 3306 -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE > $FILENAME_PATH

echo "MySQL dump completed"

gsutil cp $FILENAME_PATH gs://$BACKUP_BUCKET/$DATE.sql

echo "Dump uploaded"

gsutil ls gs://$BACKUP_BUCKET/ | while read -r file; do
    file=$(echo "$file" | tr -d '\r\n')
    if [[ ! "$file" =~ \.sql$ ]]; then
        continue
    fi

    filename=$(basename "$file" .sql)
    if [[ $filename =~ ^[0-9]{2}-[0-9]{2}-[0-9]{4}$ ]]; then
        file_date=$(date -d "$(echo $filename | sed 's/\([0-9]\{2\}\)-\([0-9]\{2\}\)-\([0-9]\{4\}\)/\3-\2-\1/')" +%s 2>/dev/null)
        if [ $? -ne 0 ]; then
            echo "Error parsing date from filename: $filename"
            continue
        fi

        current_date=$(date +%s)
        age_days=$(( (current_date - file_date) / 86400 ))
        if [ $age_days -gt $BACKUP_RETENTION_DAYS ]; then
            gsutil rm "$file"
            echo "Deleted $file, $age_days days old"
        fi

    else
        echo "Skipping invalid filename format: $filename"
    fi
done

rm $FILENAME_PATH