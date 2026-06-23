# Backup & Restore Guide

## Overview

PulseFort uses PostgreSQL logical backups generated with `pg_dump`. Backups are stored locally and can be restored using the provided recovery script.

The backup workflow supports:

* Disaster recovery
* Data restoration
* Environment migration
* Operational rollback

---

## Create a Backup

```bash
./scripts/backup.sh
```

Example output:

```text
backups/pulsefort_20260623_120000.sql
```

Each backup contains a complete PostgreSQL database export.

---

## Backup Retention

Backups older than 7 days are automatically removed.

```bash
find backups -type f -name "*.sql" -mtime +7 -delete
```

This keeps storage usage predictable while preserving recent recovery points.

---

## Backup Security

Restrict access to backup files:

```bash
chmod 700 backups
chmod 600 backups/*.sql
```

Only authorized administrators should have access to backup data.

---

## Restore a Backup

```bash
./scripts/restore.sh backups/<backup-file>.sql
```

Example:

```bash
./scripts/restore.sh backups/pulsefort_20260623_120000.sql
```

The selected backup is imported into PostgreSQL and the database state is restored.

---

## Validate Recovery

### Verify Database

```bash
docker compose exec postgres \
psql -U pulsefort -d pulsefort
```

### Verify Application Readiness

```bash
curl http://localhost/ready
```

Expected response:

```json
{
  "ready": true,
  "postgres": true,
  "redis": true
}
```

### Verify Running Services

```bash
docker ps
```

Ensure PostgreSQL, Redis, FastAPI, NGINX, Prometheus, and Grafana are healthy.

---

## Disaster Recovery Workflow

```text
Restore Infrastructure
        |
        v
Start Containers
        |
        v
Restore Database
        |
        v
Verify PostgreSQL
        |
        v
Verify Application
        |
        v
Verify Monitoring
        |
        v
Resume Operations
```

---

## Future Enhancements

* Scheduled backups
* Compressed archives
* AWS S3 backup storage
* Backup integrity verification
* Encrypted backups
* Cross-region replication

---

PulseFort includes documented backup and recovery procedures to ensure operational continuity and reliable disaster recovery.
