# Operations Runbook

## Overview

This runbook provides operational procedures, validation steps, troubleshooting workflows, and recovery actions for managing the PulseFort platform. Use it to diagnose issues, verify platform health, perform routine maintenance, and restore service during incidents.

---

## Platform Health Verification

Run after deployments, infrastructure changes, maintenance, or incident recovery.

**Health**

```bash
curl http://localhost/health
```

```json
{ "status": "healthy" }
```

**Liveness**

```bash
curl http://localhost/live
```

```json
{ "alive": true }
```

**Readiness**

```bash
curl http://localhost/ready
```

```json
{ "ready": true, "postgres": true, "redis": true }
```

---

## Container Operations

```bash
docker compose ps               # view running services
docker compose up -d            # start platform
docker compose down             # stop platform
docker compose restart          # restart all services
docker compose restart app      # restart application
docker compose restart postgres # restart database
docker compose restart redis    # restart cache
docker compose restart nginx    # restart proxy
```

Expected services: `nginx`, `app`, `postgres`, `redis`, `prometheus`, `grafana`, `node-exporter`, `cadvisor`

---

## Log Management

```bash
docker compose logs             # all service logs
docker compose logs -f          # stream logs
docker compose logs app         # application
docker compose logs nginx       # reverse proxy
docker compose logs postgres    # database
docker compose logs redis       # cache
docker compose logs prometheus  # metrics collection
docker compose logs grafana     # dashboards
docker compose logs cadvisor    # container metrics
docker compose logs node-exporter # host metrics
```

---

## Deployment Operations

**Standard Deployment**

```bash
bash scripts/deploy.sh
```

Pulls latest source, rebuilds containers, restarts services, validates deployment.

**Health-Gated Deployment**

```bash
bash scripts/zero-downtime-deploy.sh
```

Includes readiness verification, failure detection, and rollback support. Use for production deployments.

---

## Database Operations

**Create backup**

```bash
bash scripts/backup.sh
```

**Restore backup**

```bash
bash scripts/restore.sh backups/<backup-file>.sql
```

**Verify database connectivity**

```bash
docker compose exec postgres psql -U pulsefort -d pulsefort
```

**Verify data**

```sql
SELECT * FROM users;
```

---

## Terraform Operations

```bash
cd terraform/environments/prod

terraform init       # initialize providers
terraform validate   # validate configuration
terraform plan       # review planned changes
terraform apply      # provision infrastructure
terraform destroy    # remove infrastructure (use with caution)
```

---

## Security Verification

```bash
sudo ufw status                          # firewall rules
sudo fail2ban-client status sshd         # brute-force protection
sudo sshd -t                             # SSH configuration (no output = valid)
```

---

## Monitoring Verification

**Prometheus targets**

```
docker exec -it pulsefort-prometheus wget -qO- http://localhost:9090/-/healthy
```

All targets should report `UP`.

**Grafana dashboards**

```
https://SERVER_IP/grafana/
```

Verify datasource connected and dashboards rendering.

**Application metrics**

```bash
curl http://localhost/metrics
```

---

## Incident Response

### Application Unavailable

Symptoms: health endpoint fails, API requests fail, readiness endpoint unavailable.

```bash
docker compose ps
docker compose logs app
docker compose logs postgres
docker compose logs redis
docker compose restart app
curl http://localhost/ready
```

### Database Failure

```bash
docker compose logs postgres
docker compose ps
bash scripts/restore.sh backups/<backup-file>.sql
curl http://localhost/ready
```

### Redis Failure

```bash
docker compose logs redis
docker compose restart redis
curl http://localhost/ready
```

### High CPU Usage

Review Grafana dashboards, Node Exporter metrics, and cAdvisor container metrics. Identify the resource-intensive container, review its logs, and restart if required.

### Monitoring Data Missing

```bash
docker compose logs prometheus
docker compose logs grafana
docker compose restart prometheus
docker compose restart grafana
```

Verify targets under Prometheus → Status → Targets.

---

## Disaster Recovery Procedure

1. Provision infrastructure via Terraform
2. Configure networking and security groups
3. Deploy PulseFort via deployment script
4. Restore latest database backup
5. Verify PostgreSQL connectivity
6. Verify Redis availability
7. Validate monitoring stack
8. Verify security controls
9. Confirm readiness endpoint returns healthy
10. Resume operations

---

## Post-Incident Validation Checklist

- All containers running
- Health endpoint operational
- Readiness endpoint operational
- PostgreSQL accessible
- Redis accessible
- Prometheus collecting metrics
- Grafana dashboards functional
- Security controls active
- Backup procedures operational

The platform should not be considered fully restored until all checks pass.

---

## Conclusion

This runbook covers the core operational procedures for deploying, validating, troubleshooting, and recovering PulseFort. Following documented workflows helps operators respond consistently to incidents and maintain platform reliability over time.