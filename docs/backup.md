# PulseFort Backup & Restore Guide

## Overview

PulseFort uses PostgreSQL logical backups generated with:

```bash
pg_dump
```

Backups are stored in:

```text
backups/
```

---

## Creating Backups

Run:

```bash
./scripts/backup.sh
```

Example:

```text
backups/pulsefort_20260622_120000.sql
```

---

## Backup Retention

Retention Policy:

- Keep backups for 7 days
- Automatically remove backups older than 7 days

Implemented in:

```text
scripts/backup.sh
```

Command:

```bash
find backups \
-type f \
-name "*.sql" \
-mtime +7 \
-delete
```

---

## Backup Security

Directory Permissions:

```bash
chmod 700 backups
```

Backup File Permissions:

```bash
chmod 600 backups/*.sql
```

Only administrators should have access.

---

## Restore Procedure

Restore:

```bash
./scripts/restore.sh backups/<file>.sql
```

Example:

```bash
./scripts/restore.sh \
backups/pulsefort_20260622_120000.sql
```

---

## Recovery Validation

After restore:

Verify PostgreSQL:

```bash
docker compose exec postgres \
psql -U pulsefort -d pulsefort
```

Verify Users Table:

```sql
SELECT * FROM users;
```

Verify Application:

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

1. Provision server
2. Start Docker Compose stack
3. Restore database backup
4. Validate PostgreSQL
5. Validate Redis
6. Validate Application
7. Validate Monitoring
8. Resume service

---

## Recommended Future Enhancements

- Compressed backups
- S3 backup storage
- Automated daily backups
- Backup integrity verification
- Encrypted backups