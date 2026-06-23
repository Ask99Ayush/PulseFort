# Architecture Guide

## Overview

PulseFort is a production-oriented backend platform built to demonstrate modern DevOps, cloud infrastructure, security, observability, and deployment practices. The application layer remains intentionally lightweight so the focus stays on infrastructure automation, operational excellence, monitoring, and reliability.

The platform follows a layered architecture that separates networking, application services, data services, monitoring, and deployment automation.

---

## Architecture Goals

* Infrastructure as Code
* Security by Default
* Operational Simplicity
* Full Observability
* High Reliability
* Automated Deployments

---

## High-Level Architecture

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

This architecture provides a single secure entry point while keeping backend services isolated from direct public access.

---

## Infrastructure Architecture

Infrastructure is provisioned using Terraform on AWS.

```text
AWS
└── VPC
    └── Public Subnet
        ├── Internet Gateway
        ├── Route Table
        ├── Security Group
        ├── EC2 Instance
        └── Elastic IP
```

### Publicly Exposed Ports

```text
22    SSH
80    HTTP
443   HTTPS
```

All other services remain accessible only through the Docker network.

---

## Compute Architecture

A single EC2 instance hosts the complete platform using Docker Compose.

Responsibilities include:

* Application hosting
* Reverse proxy management
* Database hosting
* Cache management
* Monitoring and observability
* Deployment execution

This approach keeps the environment cost-effective, reproducible, and easy to operate.

---

## Container Architecture

```text
Docker Host
├── NGINX
├── FastAPI
├── PostgreSQL
├── Redis
├── Prometheus
├── Grafana
├── Node Exporter
└── cAdvisor
```

### Application Services

| Service    | Purpose               |
| ---------- | --------------------- |
| FastAPI    | API Layer             |
| PostgreSQL | Persistent Storage    |
| Redis      | Cache Layer           |
| NGINX      | Reverse Proxy & HTTPS |

### Monitoring Services

| Service       | Purpose            |
| ------------- | ------------------ |
| Prometheus    | Metrics Collection |
| Grafana       | Dashboards         |
| Node Exporter | Host Metrics       |
| cAdvisor      | Container Metrics  |

---

## Reverse Proxy Architecture

NGINX acts as the centralized ingress layer.

```text
Client
   |
   v
NGINX
   |
   +--> FastAPI
   +--> Grafana
   +--> Prometheus
```

Responsibilities:

* HTTPS termination
* Request routing
* Security headers
* Rate limiting
* Access logging

---

## Application Architecture

The FastAPI application is organized using a layered structure.

```text
app/
├── api/
├── core/
├── db/
├── models/
├── schemas/
├── services/
└── main.py
```

### Health Endpoints

```text
GET /health
GET /live
GET /ready
GET /metrics
```

### Functional Endpoints

```text
POST /users
GET  /users
GET  /users/{id}
DELETE /users/{id}

POST /cache
GET  /cache/{key}
```

---

## Data Architecture

### PostgreSQL

Provides persistent relational storage for application data.

Features:

* ACID transactions
* Durable storage
* Volume-backed persistence
* Containerized deployment

### Redis

Provides high-speed in-memory caching.

Features:

* Low-latency access
* Reduced database load
* Improved response times

---

## Monitoring Architecture

```text
FastAPI       ──► Prometheus
Node Exporter ──► Prometheus
cAdvisor      ──► Prometheus
                     |
                     v
                  Grafana
```

### Access Paths

```text
https://SERVER_IP/prometheus/
https://SERVER_IP/grafana/
```

### Monitoring Components

| Component     | Purpose              |
| ------------- | -------------------- |
| Prometheus    | Metrics Collection   |
| Grafana       | Visualization        |
| Node Exporter | Host Monitoring      |
| cAdvisor      | Container Monitoring |

---

## Security Architecture

Security is enforced across multiple layers.

| Layer       | Controls                               |
| ----------- | -------------------------------------- |
| AWS         | Security Groups                        |
| Host        | UFW, Fail2Ban, SSH Hardening           |
| NGINX       | HTTPS, Security Headers, Rate Limiting |
| Containers  | Network Isolation                      |
| CI/CD       | GitHub Secrets                         |
| Application | Health Validation                      |

---

## Reliability Architecture

### Health Checks

```text
GET /health
GET /live
GET /ready
```

### Reliability Features

* Docker health checks
* Automatic container restart policies
* Dependency validation
* Deployment health verification
* Operational runbooks

---

## Backup Architecture

```text
PostgreSQL
     |
     v
 backup.sh
     |
     v
 Backup Storage

Restore Flow

Backup Storage
     |
     v
 restore.sh
     |
     v
 PostgreSQL
```

Features:

* Automated backups
* Timestamped backup files
* Retention management
* Recovery procedures

---

## CI/CD Architecture

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

### Pipeline Stages

* Validation
* Docker Build
* Terraform Validation
* Deployment
* Health Verification

---

## Future Enhancements

* Let's Encrypt SSL
* Cloudflare Integration
* Blue-Green Deployments
* Centralized Logging
* Alerting Pipelines
* Multi-Environment Infrastructure

---

## Conclusion

PulseFort demonstrates a production-style architecture combining Infrastructure as Code, containerization, monitoring, security hardening, automated deployments, and operational reliability. The platform prioritizes simplicity, visibility, and automation while reflecting real-world DevOps and platform engineering practices.
