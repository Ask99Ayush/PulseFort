# Architecture Guide

## Overview

PulseFort is a production-focused backend platform designed to demonstrate modern DevOps, cloud infrastructure, observability, security, and deployment practices. The application logic is intentionally simple, allowing the architecture to highlight operational excellence, automation, and reliability.

The system follows a layered architecture where each component has a clear responsibility. This improves maintainability, scalability, and operational clarity while keeping the deployment model simple.

---

## Architecture Goals

- **Infrastructure First** — Fully automated and reproducible environments
- **Operational Simplicity** — Easy deployment, debugging, and maintenance
- **Security by Default** — Built-in protection across all layers
- **Observability** — Full visibility into system behavior
- **Reliability** — Failure detection and recovery mechanisms
- **Automation** — Minimal manual intervention through CI/CD

---

## High-Level Architecture

PulseFort is organized into five layers: User Access, Reverse Proxy, Application, Data, and Monitoring.

```
Users → Internet → NGINX → FastAPI → PostgreSQL / Redis

Monitoring:
Node Exporter ──► Prometheus ──► Grafana
cAdvisor      ──► Prometheus
FastAPI       ──► Prometheus
```

This design separates concerns while remaining suitable for a single-server deployment.

---

## Infrastructure Architecture

Infrastructure is provisioned using Terraform on AWS.

```
VPC (10.0.0.0/16)
└── Public Subnet (10.0.1.0/24)
    ├── Internet Gateway
    ├── Route Table
    ├── Security Groups
    ├── EC2 Instance
    └── Elastic IP
```

**Security Group — Allowed Inbound**

```
22    SSH
80    HTTP
443   HTTPS
```

**Internal Only**

```
PostgreSQL    Redis    Prometheus    Grafana
Node Exporter    cAdvisor
```

---

## Compute Architecture

A single EC2 instance hosts all services via Docker Compose.

Responsibilities:

- Running application and monitoring containers
- Hosting the NGINX reverse proxy
- Managing PostgreSQL and Redis

This model keeps the deployment simple, cost-effective, and easy to debug.

---

## Container Architecture

Docker Compose orchestrates all services on a single host.

```
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

Benefits: consistent environments, service isolation, portable deployments.

---

## Reverse Proxy Architecture

NGINX is the single entry point for all inbound traffic.

```
Client → NGINX
           ├── FastAPI
           └── Grafana

Internal Monitoring Network
Prometheus
Node Exporter
cAdvisor

Responsibilities:

- HTTPS termination
- Request routing
- Security headers
- Rate limiting
- Access logging

---

## Application Architecture

Built with FastAPI, structured for clarity and separation of concerns.

```
app/
├── api/
├── core/
├── db/
├── models/
├── schemas/
├── services/
└── main.py
```

**API Endpoints**

```
GET  /           Root
GET  /health     Health check
GET  /live       Liveness
GET  /ready      Readiness
POST /users      Create user
GET  /users      List users
GET  /users/{id} Get user
DELETE /users/{id} Delete user
POST /cache      Set cache
GET  /cache/{key} Get cache
GET  /metrics    Prometheus metrics
```

**Layers**

- API Layer — handles requests and responses
- Service Layer — business logic and dependency coordination
- Models — database schema via SQLAlchemy

---

## Data Architecture

**PostgreSQL** handles persistent storage with ACID compliance, strong consistency, and reliable transactions. Data is persisted through a Docker volume so it survives container restarts.

**Redis** provides in-memory caching to reduce database load and improve response latency.

---

## Monitoring Architecture

```
FastAPI       ──► Prometheus ──► Grafana
Node Exporter ──► Prometheus
cAdvisor      ──► Prometheus
```

| Component     | Purpose                  |
|---------------|--------------------------|
| Prometheus    | Metrics collection       |
| Grafana       | Visualization dashboards |
| Node Exporter | Host-level metrics       |
| cAdvisor      | Container metrics        |

---

## Security Architecture

Security is enforced across multiple layers.

| Layer          | Controls                                    |
|----------------|---------------------------------------------|
| Infrastructure | AWS Security Groups, network segmentation   |
| Host           | UFW, Fail2Ban, SSH hardening                |
| Containers     | Non-root execution, isolated networking     |
| Secrets        | Environment variables, GitHub Secrets       |

---

## Reliability Architecture

**Health Checks**

```
GET /health    Application availability
GET /live      Process health
GET /ready     Dependency validation (PostgreSQL, Redis)
```

Docker restart policies automatically recover failed services. Deployments are health-gated and validated before being considered successful.

---

## Backup Architecture

```
Backup:   PostgreSQL → backup.sh  → backups/
Restore:  backups/   → restore.sh → PostgreSQL
```

Timestamped backups with a 7-day retention policy. Backup files are permission-restricted and intended for administrator access only.

---

## CI/CD Architecture

```
Developer → GitHub → GitHub Actions → Validation → Build → Deployment → Health Check
```

**Stages**

- Validation — Python, Docker, Terraform checks
- Deployment — service restart, readiness verification

---

## Future Enhancements

- Cloudflare CDN and WAF integration
- Automated SSL via Let's Encrypt
- Blue-green deployments
- Centralized log aggregation
- Alerting and notification pipelines
- Multi-environment Terraform workspaces

---

## Conclusion

PulseFort demonstrates a complete production-ready architecture combining infrastructure automation, containerization, monitoring, security, and deployment workflows. It emphasizes operational simplicity and visibility while reflecting practices used in real-world cloud environments.