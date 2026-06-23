#!/bin/bash

set -euo pipefail

if [ ! -f .env ]; then
    echo ".env file not found"
    exit 1
fi

set -a
source .env
set +a

BACKUP_DIR="./backups"

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

BACKUP_FILE="${BACKUP_DIR}/pulsefort_${TIMESTAMP}.sql"

mkdir -p "${BACKUP_DIR}"

chmod 700 "${BACKUP_DIR}"

echo "Creating PostgreSQL backup..."

docker compose exec -T postgres \
pg_dump \
-U "${POSTGRES_USER}" \
-d "${POSTGRES_DB}" \
> "${BACKUP_FILE}"

if [ ! -s "${BACKUP_FILE}" ]; then
    echo "Backup failed"
    exit 1
fi

chmod 600 "${BACKUP_FILE}"

echo "Backup created: ${BACKUP_FILE}"

echo "Applying retention policy..."

find "${BACKUP_DIR}" \
-type f \
-name "*.sql" \
-mtime +7 \
-delete

echo "Retention completed."

echo "Backup process finished successfully."