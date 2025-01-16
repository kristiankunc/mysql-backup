# MYSQL-BACKUP

A simple Docker container used to run a backup of a MySQL database and store it in in a Google Cloud bucket.

## Configuration options

Standard Docker MySQL environment variables are required: `[MYSQL_USER, MYSQL_PASSWORD, MYSQL_HOST, MYSQL_DATABASE]` with the addition of the following:

- **BACKUP_BUCKET**: The name of the Google Cloud bucket where the backups will be stored (excluding the gs:// protocol) *(ex: peter-parker-backups/main-database)*
- **BACKUP_CREDENTIALS_PATH**: The (absolute) path to the Google Cloud service account credentials file *(ex: /etc/mysql-backup/credentials.json)*
- **BACKUP_RETENTION_DAYS**: The number of days to keep the backups in the bucket *(ex: 7)*
- **BACKUP_PROJECT_ID**: The Google Cloud project ID where the bucket is located *(ex: peter-parker-123456)*
