# Deployment Guide

## Overview

This guide covers infrastructure provisioning, application deployment, service verification, and CI/CD integration for PulseFort.

PulseFort runs as a containerized platform using Docker Compose on an Ubuntu server. Infrastructure is provisioned through Terraform. Deployments can be performed manually or automated through GitHub Actions.

---

## Deployment Architecture

```
Internet
    │
    ▼
NGINX Reverse Proxy
    │
    ▼
FastAPI Application
   ├── PostgreSQL
   └── Redis

Monitoring Stack
   ├── Prometheus
   ├── Grafana
   ├── Node Exporter
   └── cAdvisor
```

---

## Prerequisites

**Operating System**

- Ubuntu 22.04 LTS or later

**Required Software**

- Docker Engine
- Docker Compose
- Git

**Verify installation**

```bash
docker --version
docker compose version
git --version
```

**Network — Required Ports**

| Port | Service    |
|------|------------|
| 22   | SSH        |
| 80   | HTTP       |
| 443  | HTTPS      |



Grafana is exposed through NGINX over HTTPS.

Prometheus, Node Exporter, and cAdvisor remain internal-only services and are not directly exposed to the public internet.

---

## Clone Repository

```bash
git clone <repository-url>
cd PulseFort
```

---

## Environment Configuration

```bash
cp .env.example .env
```

Update values for:

- Database credentials
- Redis configuration
- Monitoring credentials
- Application settings

---

## Build and Start

**Build containers**

```bash
docker compose build
```

**Start all services**

```bash
docker compose up -d
```

**Verify running containers**

```bash
docker compose ps
```

Expected services: `nginx`, `app`, `postgres`, `redis`, `prometheus`, `grafana`, `node-exporter`, `cadvisor`

---

## Service Verification

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

