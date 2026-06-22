#!/bin/bash

set -e

set -a
source .env
set +a

if [ -z "$1" ]; then
    echo "Usage:"
    echo "./scripts/restore.sh backups/file.sql"
    exit 1
fi

BACKUP_FILE="$1"

if [ ! -f "${BACKUP_FILE}" ]; then
    echo "Backup file not found."
    exit 1
fi

echo "Restoring database..."

cat "${BACKUP_FILE}" | docker compose exec -T postgres \
psql \
-U "${POSTGRES_USER}" \
-d "${POSTGRES_DB}"

echo "Restore completed."