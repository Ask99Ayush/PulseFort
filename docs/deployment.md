# Deployment Guide

## Prerequisites

Server:

- Ubuntu 22.04+
- Docker
- Docker Compose
- Git

---

## Clone Repository

```bash
git clone <repository-url>

cd PulseFort
```

---

## Configure Environment

```bash
cp .env.example .env
```

Update values.

---

## Build

```bash
docker compose build
```

---

## Start

```bash
docker compose up -d
```

---

## Verify

```bash
docker compose ps
```

---

Application:

```bash
curl http://localhost/ready
```

---

## Monitoring

Grafana:

```text
http://SERVER_IP:3000
```

Prometheus:

```text
http://SERVER_IP:9090
```

---

## Deployment Script

```bash
bash scripts/deploy.sh
```

---

## CI/CD

Push to:

```text
main
```

GitHub Actions automatically deploys.