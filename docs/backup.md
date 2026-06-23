# Backup & Restore Guide

## Overview

PulseFort uses PostgreSQL logical backups generated through `pg_dump`. Backups are timestamped, stored locally, and can be restored using the provided recovery scripts. The strategy supports disaster recovery, data migration, and rollback scenarios.

---

## Creating a Backup

```bash
./scripts/backup.sh
```

Example output:

```
backups/pulsefort_20260622_120000.sql
```

Each file contains a complete logical export of the PostgreSQL database.

---

## Retention Policy

Backups older than 7 days are automatically removed during each backup run.

```bash
find backups \
  -type f \
  -name "*.sql" \
  -mtime +7 \
  -delete
```

This keeps storage usage predictable while maintaining recent recovery points.

---

## Backup Security

Restrict access to the backup directory and its contents.

```bash
chmod 700 backups
chmod 600 backups/*.sql
```

Only authorized administrators should have read access to backup files.

---

## Restore Procedure

```bash
./scripts/restore.sh backups/<backup-file>.sql
```

Example:

```bash
./scripts/restore.sh backups/pulsefort_20260622_120000.sql
```

The restore script imports the selected backup into PostgreSQL and rebuilds the database state.

---

## Recovery Validation

After a restore, verify the platform is fully operational.

**Verify PostgreSQL**

```bash
docker compose exec postgres psql -U pulsefort -d pulsefort
```

**Verify Application Data**

```sql
SELECT * FROM users;
```

**Verify Platform Readiness**

```bash
curl http://localhost/ready
```

Expected:

```json
{
  "ready": true,
  "postgres": true,
  "redis": true
}
```

---

## Disaster Recovery Workflow

1. Provision infrastructure
2. Start the Docker Compose stack
3. Restore the latest database backup
4. Verify PostgreSQL connectivity
5. Verify Redis availability
6. Validate application readiness
7. Confirm monitoring services are running
8. Resume normal operations

---

## Future Enhancements

- Compressed backup archives
- Automated scheduled backups
- AWS S3 remote storage
- Backup integrity verification
- Encrypted archives
- Cross-region replication