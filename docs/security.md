# Security Guide

## Overview

Security is a fundamental design principle within PulseFort and is implemented across infrastructure, operating systems, containers, deployment pipelines, and operational workflows. The objective is to minimize attack surface, protect critical services, prevent credential exposure, and enforce production-oriented security practices.

PulseFort follows a layered security model where controls are applied at multiple levels to provide defense in depth.

---

## Security Architecture

```
Internet
    │
    ▼
AWS Security Groups
    │
    ▼
UFW Firewall
    │
    ▼
NGINX Reverse Proxy
    │
    ▼
Application Containers
    │
    ▼
PostgreSQL / Redis
```

Additional layers: Fail2Ban, SSH Hardening, GitHub Secrets, Container Isolation.

---

## Security Principles

Least privilege access, defense in depth, secure defaults, infrastructure isolation, credential protection, and continuous validation guide all infrastructure and operational decisions.

---

## Infrastructure Security

**AWS Security Groups — Publicly Accessible**

| Port | Service |
|------|---------|
| 22   | SSH     |
| 80   | HTTP    |
| 443  | HTTPS   |

**Restricted — Internal Only**

| Service       | Port |
|---------------|------|
| PostgreSQL    | 5432 |
| Redis         | 6379 |
| Prometheus    | 9090 |
| Grafana       | 3000 |
| Node Exporter | 9100 |
| cAdvisor      | 8080 |

These services are inaccessible from the public internet by design.

---

## Host Security

**UFW Firewall**

Allowed rules:

```
22/tcp
80/tcp
443/tcp
```

All other inbound traffic is denied by default.

Verify:

```bash
sudo ufw status numbered
```

Allow SSH access first, then enable UFW. Never enable UFW before confirming SSH access to avoid lockout.

---

## Fail2Ban

Protects SSH against brute-force and automated login attacks.

| Setting    | Value      |
|------------|------------|
| Find Time  | 10 minutes |
| Max Retry  | 5 attempts |
| Ban Time   | 1 hour     |

Verify:

```bash
sudo fail2ban-client status sshd
```

Review active jails, banned addresses, and failed login attempts.

---

## SSH Hardening

**Implemented Controls**

- Root login disabled
- Password authentication disabled
- Public key authentication required
- Reduced login attempts
- Administrative access restriction

**Validate configuration**

```bash
sudo sshd -t
```

No output means the configuration is valid.

**Lockout Prevention**

Before disabling password authentication:

1. Upload SSH public key
2. Confirm key-based login works
3. Open a second SSH session
4. Disable password authentication
5. Restart SSH service
6. Verify access from the second session

Never disable password authentication without a confirmed backup session.

---

## Container Security

**Implemented Controls**

- Non-root containers
- Service isolation via Docker networks
- Environment-based configuration
- Health checks on all services
- Minimal runtime dependencies

**Internal Networking**

```
FastAPI
 ├── PostgreSQL
 └── Redis
```

Database services are not exposed to public interfaces.

**cAdvisor Exception**

cAdvisor requires elevated Docker visibility for container monitoring. Additional permissions are scoped strictly to metrics collection and do not extend application privileges.

---

## Secret Management

**GitHub Secrets — CI/CD Pipeline**

Infrastructure:

```
SERVER_HOST
SERVER_USER
SERVER_SSH_KEY
```

Database:

```
POSTGRES_DB
POSTGRES_USER
POSTGRES_PASSWORD
```

Monitoring:

```
GRAFANA_ADMIN_USER
GRAFANA_ADMIN_PASSWORD
```

**Environment Variables — Server Runtime**

Stored in `.env`. Never commit this file.

Verify `.gitignore` includes:

```
.env
```

---

## Deployment Security

GitHub Actions handles all automated deployments.

Controls applied:

- Encrypted GitHub Secrets
- SSH key authentication
- Automated validation before deployment
- Health and readiness verification after deployment

No credentials are hardcoded anywhere in the codebase.

---

## Monitoring Exposure Policy

**Public access allowed:**

```
80    HTTP
443   HTTPS
```

Monitoring Access

Grafana is exposed through NGINX:

https://SERVER_IP/grafana/

Prometheus is internal-only and not publicly exposed.

Node Exporter and cAdvisor remain internal-only.
8080  cAdvisor
```

---

## Backup Security

Backup files may contain sensitive production data.

```bash
chmod 700 backups
chmod 600 backups/*.sql
```

Recommended practices: encrypt archives, restrict administrator access, test recovery regularly, store critical backups offsite.

---

## Security Validation Checklist

```bash
sudo ufw status                        # firewall
sudo fail2ban-client status sshd       # brute-force protection
sudo sshd -t                           # SSH config
docker compose ps                      # container status
```

Secrets review:

- No credentials in repository
- No secrets in logs or documentation
- No secrets in container images

---

## Future Enhancements

- Cloudflare WAF and DDoS protection
- Let's Encrypt automation
- Container image scanning
- Vulnerability scanning
- Secret rotation policies
- Centralized log aggregation
- Intrusion detection

---

## Conclusion

PulseFort implements a layered security model covering infrastructure protection, host hardening, container isolation, secret management, deployment security, and monitoring exposure controls. By combining AWS Security Groups, UFW, Fail2Ban, SSH hardening, and secure CI/CD workflows, the platform demonstrates practical security practices applied in modern production environments.