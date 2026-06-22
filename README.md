# PulseFort

Production-grade DevOps assignment demonstrating:

- FastAPI
- PostgreSQL
- Redis
- Docker
- Docker Compose
- NGINX
- Prometheus
- Grafana
- Node Exporter
- cAdvisor
- GitHub Actions
- Terraform
- UFW
- Fail2Ban

---

## Features

### Application

- User CRUD
- Redis Cache
- Health Checks
- Readiness Checks
- Liveness Checks
- Metrics Endpoint

### Infrastructure

- Dockerized Services
- Reverse Proxy
- Monitoring Stack
- Security Hardening
- Backup & Restore
- Infrastructure as Code

### Operations

- Automated Deployment
- Health Verification
- Disaster Recovery
- Observability

---

## Architecture

Client
→ NGINX
→ FastAPI
→ PostgreSQL

FastAPI
→ Redis

Prometheus
→ Application Metrics

Grafana
→ Prometheus

---

## Quick Start

Build:

```bash
docker compose build
```

Run:

```bash
docker compose up -d
```

Verify:

```bash
curl http://localhost/ready
```

---

## Monitoring

Grafana:

```text
http://localhost:3000
```

Prometheus:

```text
http://localhost:9090
```

---

## Infrastructure

Terraform:

```bash
cd terraform/environments/prod

terraform init

terraform plan
```

---

## Security

Implemented:

- UFW
- Fail2Ban
- SSH Hardening
- Non-root Containers

See:

```text
docs/security.md
```