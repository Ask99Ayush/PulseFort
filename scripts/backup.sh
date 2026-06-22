#!/bin/bash

set -e

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

chmod 600 "${BACKUP_FILE}"

echo "Backup created: ${BACKUP_FILE}"

echo "Applying retention policy..."

find "${BACKUP_DIR}" \
-type f \
-name "*.sql" \
-mtime +7 \
-delete

echo "Retention completed."