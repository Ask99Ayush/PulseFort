# Deployment Guide

## Overview

PulseFort is deployed as a containerized platform using Docker Compose on AWS EC2. Infrastructure is provisioned with Terraform, while application deployment is automated through GitHub Actions.

---

## Deployment Architecture

```text
Internet
   |
   v
NGINX (HTTPS)
   |
   +--> FastAPI
   +--> Grafana (/grafana)
   +--> Prometheus (/prometheus)

Internal Docker Network
   |
   +--> PostgreSQL
   +--> Redis
   +--> Node Exporter
   +--> cAdvisor
```

---

## Prerequisites

### Operating System

* Ubuntu 22.04 LTS or later

### Required Software

* Docker Engine
* Docker Compose
* Git

### Verify Installation

```bash
docker --version
docker compose version
git --version
```

---

## Network Requirements

| Port | Purpose |
| ---- | ------- |
| 22   | SSH     |
| 80   | HTTP    |
| 443  | HTTPS   |

Only ports **80** and **443** are publicly exposed.

---

## Clone Repository

```bash
git clone https://github.com/Ask99Ayush/PulseFort.git
cd PulseFort
```

---

## Configure Environment

```bash
cp .env.example .env
```

Update values as required:

* PostgreSQL credentials
* Redis settings
* Grafana credentials
* Application configuration

---

## Deploy Platform

Build and start all services:

```bash
docker compose up -d --build
```

Verify containers:

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

## Verify Deployment

### Application Health

```bash
curl http://localhost/health
```

### Application Readiness

```bash
curl http://localhost/ready
```

### Running Containers

```bash
docker ps
```

---

## Access Services

```text
Application
https://SERVER_IP/

Grafana
https://SERVER_IP/grafana/

Prometheus
https://SERVER_IP/prometheus/
```

---

## CI/CD Deployment

Production deployments are automated through GitHub Actions.

```text
Developer
    |
    v
GitHub
    |
    v
GitHub Actions
    |
    v
Validate
    |
    v
Build
    |
    v
Deploy
    |
    v
Health Checks
    |
    v
Production
```

---

## Troubleshooting

View container status:

```bash
docker compose ps
```

View logs:

```bash
docker compose logs -f
```

Restart services:

```bash
docker compose restart
```

---

PulseFort follows a production-oriented deployment model with infrastructure automation, container orchestration, HTTPS routing, monitoring, and automated CI/CD workflows.
