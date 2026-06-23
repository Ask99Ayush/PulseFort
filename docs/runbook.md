# Operations Runbook

## Overview

This runbook provides operational procedures for deploying, validating, monitoring, troubleshooting, and recovering the PulseFort platform.

---

## Platform Validation

### Health Check

```bash
curl http://localhost/health
```

### Readiness Check

```bash
curl http://localhost/ready
```

### Running Containers

```bash
docker compose ps
```

Expected services:

```text
nginx
app
postgres
redis
prometheus
grafana
node-exporter
cadvisor
```

---

## Container Operations

Start platform:

```bash
docker compose up -d
```

Stop platform:

```bash
docker compose down
```

Restart all services:

```bash
docker compose restart
```

Restart individual service:

```bash
docker compose restart app
docker compose restart nginx
docker compose restart postgres
docker compose restart redis
```

---

## Log Management

View all logs:

```bash
docker compose logs
```

Stream logs:

```bash
docker compose logs -f
```

Service logs:

```bash
docker compose logs app
docker compose logs nginx
docker compose logs postgres
docker compose logs redis
docker compose logs prometheus
docker compose logs grafana
```

---

## Deployment Operations

Deploy latest version:

```bash
bash scripts/deploy.sh
```

Zero-downtime deployment:

```bash
bash scripts/zero-downtime-deploy.sh
```

Verify deployment:

```bash
curl http://localhost/ready
docker compose ps
```

---

## Backup & Recovery

Create backup:

```bash
bash scripts/backup.sh
```

Restore backup:

```bash
bash scripts/restore.sh backups/<backup-file>.sql
```

Verify PostgreSQL:

```bash
docker compose exec postgres \
psql -U pulsefort -d pulsefort
```

---

## Monitoring Operations

### Grafana

```text
https://SERVER_IP/grafana/
```

### Prometheus

```text
https://SERVER_IP/prometheus/
```

### Verify Targets

```text
Status → Targets
```

Expected:

```text
pulsefort-app   UP
prometheus      UP
node-exporter   UP
cadvisor        UP
```

### Verify Metrics

```bash
curl http://localhost/metrics
```

---

## Terraform Operations

```bash
cd terraform/environments/prod

terraform init
terraform validate
terraform plan
terraform apply
```

Destroy infrastructure:

```bash
terraform destroy
```

---

## Security Verification

Firewall status:

```bash
sudo ufw status
```

Fail2Ban status:

```bash
sudo fail2ban-client status sshd
```

SSH configuration:

```bash
sudo sshd -t
```

---

## Incident Response

### Application Unavailable

```bash
docker compose ps
docker compose logs app
docker compose restart app
curl http://localhost/ready
```

### Database Issues

```bash
docker compose logs postgres
docker compose restart postgres
```

### Redis Issues

```bash
docker compose logs redis
docker compose restart redis
```

### Monitoring Issues

```bash
docker compose logs prometheus
docker compose logs grafana

docker compose restart prometheus
docker compose restart grafana
```

---

## Disaster Recovery

```text
Provision Infrastructure
        |
        v
Deploy Platform
        |
        v
Restore Database
        |
        v
Verify Services
        |
        v
Validate Monitoring
        |
        v
Resume Operations
```

---

## Recovery Checklist

* All containers healthy
* Health endpoint responding
* Readiness endpoint responding
* PostgreSQL operational
* Redis operational
* Prometheus targets UP
* Grafana dashboards working
* Security controls active
* Backups validated

---

PulseFort uses automated health checks, monitoring, backups, and deployment validation to ensure reliable platform operations and faster incident recovery.
