# Security Guide

## Overview

Security is implemented across infrastructure, networking, operating systems, containers, monitoring, and deployment workflows. PulseFort follows a layered security model designed to reduce attack surface, protect critical services, and enforce production-oriented security practices.

---

## Security Architecture

```text
Internet
    |
    v
AWS Security Group
    |
    v
UFW Firewall
    |
    v
NGINX (HTTPS)
    |
    +--> FastAPI
    +--> Grafana
    +--> Prometheus

Internal Docker Network
    |
    +--> PostgreSQL
    +--> Redis
    +--> Node Exporter
    +--> cAdvisor
```

Additional controls include Fail2Ban, SSH Hardening, Container Isolation, and GitHub Secrets.

---

## Security Principles

* Least Privilege Access
* Defense in Depth
* Secure Defaults
* Service Isolation
* Credential Protection
* Automated Validation

---

## Infrastructure Security

### Public Access

| Port | Service |
| ---- | ------- |
| 22   | SSH     |
| 80   | HTTP    |
| 443  | HTTPS   |

### Internal Services

| Service       | Port |
| ------------- | ---- |
| PostgreSQL    | 5432 |
| Redis         | 6379 |
| Node Exporter | 9100 |
| cAdvisor      | 8080 |

These services are accessible only through the Docker network.

---

## Host Security

### UFW Firewall

Allowed inbound traffic:

```text
22/tcp
80/tcp
443/tcp
```

Verify status:

```bash
sudo ufw status
```

All other inbound traffic is denied by default.

---

## Fail2Ban

Protects SSH against brute-force attacks.

Verify:

```bash
sudo fail2ban-client status sshd
```

Features:

* Automatic IP banning
* Failed login detection
* SSH attack mitigation

---

## SSH Hardening

Implemented controls:

* Root login disabled
* Password authentication disabled
* Public key authentication required
* Limited login attempts

Validate configuration:

```bash
sudo sshd -t
```

No output indicates a valid configuration.

---

## Container Security

Security measures include:

* Isolated Docker network
* Health checks
* Environment-based configuration
* Service separation
* Minimal container exposure

```text
FastAPI
 ├── PostgreSQL
 └── Redis
```

Backend services are not directly accessible from the internet.

---

## Monitoring Security

Monitoring services are exposed through NGINX over HTTPS.

### Grafana

```text
https://SERVER_IP/grafana/
```

### Prometheus

```text
https://SERVER_IP/prometheus/
```

### Internal Only

```text
Node Exporter
cAdvisor
PostgreSQL
Redis
```

Only ports **80** and **443** are publicly exposed.

---

## Secret Management

### GitHub Secrets

Examples:

```text
SERVER_HOST
SERVER_USER
SERVER_SSH_KEY

POSTGRES_DB
POSTGRES_USER
POSTGRES_PASSWORD

GRAFANA_ADMIN_USER
GRAFANA_ADMIN_PASSWORD
```

### Runtime Configuration

Environment variables are stored in:

```text
.env
```

Never commit `.env` files to source control.

---

## Deployment Security

GitHub Actions deployments include:

* Encrypted secrets
* SSH key authentication
* Automated validation
* Health verification
* Readiness verification

No credentials are hardcoded in the repository.

---

## Backup Security

Protect backup files:

```bash
chmod 700 backups
chmod 600 backups/*.sql
```

Recommended practices:

* Restrict administrator access
* Encrypt sensitive backups
* Store critical backups securely
* Test recovery procedures regularly

---

## Security Validation

Verify platform security:

```bash
sudo ufw status

sudo fail2ban-client status sshd

sudo sshd -t

docker compose ps
```

Review:

* Container health
* Firewall rules
* SSH configuration
* Fail2Ban status
* Secret management practices

---

## Future Enhancements

* Let's Encrypt SSL
* Cloudflare WAF
* Vulnerability Scanning
* Container Image Scanning
* Secret Rotation
* Centralized Logging
* Intrusion Detection

---

PulseFort applies security controls across infrastructure, networking, containers, monitoring, and deployment workflows to provide a secure and production-oriented operating environment.
