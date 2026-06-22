# PulseFort Operations Runbook

## Service Health Check

Application:

```bash
curl http://localhost/health
```

Readiness:

```bash
curl http://localhost/ready
```

---

## Container Status

```bash
docker compose ps
```

---

## View Logs

All Services:

```bash
docker compose logs -f
```

Specific Service:

```bash
docker compose logs -f app
```

---

## Restart Services

All:

```bash
docker compose restart
```

Application:

```bash
docker compose restart app
```

---

## Deploy Latest Version

```bash
bash scripts/deploy.sh
```

---

## Backup Database

```bash
bash scripts/backup.sh
```

---

## Restore Database

```bash
bash scripts/restore.sh backups/<file>.sql
```

---

## Terraform Operations

Initialize:

```bash
terraform init
```

Plan:

```bash
terraform plan
```

Apply:

```bash
terraform apply
```

Destroy:

```bash
terraform destroy
```

---

## Security Verification

Firewall:

```bash
sudo ufw status
```

Fail2Ban:

```bash
sudo fail2ban-client status sshd
```

SSH:

```bash
sudo sshd -t
```

---

## Monitoring Verification

Prometheus:

```text
http://SERVER_IP:9090
```

Grafana:

```text
http://SERVER_IP:3000
```

---

## Incident Response

### Application Down

1. Check Docker containers
2. Check application logs
3. Verify PostgreSQL
4. Verify Redis
5. Restart application

Commands:

```bash
docker compose ps

docker compose logs app

docker compose restart app
```

---

### Database Failure

Verify:

```bash
docker compose logs postgres
```

Restore:

```bash
bash scripts/restore.sh backups/<file>.sql
```

---

### High CPU

Check:

- Grafana Dashboard
- Node Exporter Metrics
- cAdvisor Metrics

Identify:

- Container consuming resources
- Host bottlenecks

Take action accordingly.

---

## Recovery Procedure

1. Provision Infrastructure
2. Deploy Application
3. Restore Database
4. Validate Monitoring
5. Validate Security
6. Resume Operations