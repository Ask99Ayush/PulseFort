# PulseFort Security Guide

## Firewall

UFW is used as the primary host firewall.

Allowed Ports:

- 22/tcp
- 80/tcp
- 443/tcp

All other inbound traffic is denied.

---

## Fail2Ban

Fail2Ban protects SSH from brute-force attacks.

Configuration:

- Find Time: 10 minutes
- Max Retry: 5
- Ban Time: 1 hour

---

## SSH Hardening

Applied Controls:

- Root login disabled
- Password authentication disabled
- Public key authentication required
- Reduced authentication attempts

---

## Secrets Management

### GitHub Secrets

Required:

- SERVER_HOST
- SERVER_USER
- SERVER_SSH_KEY
- POSTGRES_DB
- POSTGRES_USER
- POSTGRES_PASSWORD
- GRAFANA_ADMIN_USER
- GRAFANA_ADMIN_PASSWORD

### Server Secrets

Stored in:

```text
.env
```

Never commit:

```text
.env
```

---

## Container Security

Controls:

- Non-root containers
- Read-only configuration mounts
- Health checks
- Environment-based configuration

Exception:

cAdvisor requires elevated access.

---

## Security Validation

Verify Firewall:

```bash
sudo ufw status
```

Verify Fail2Ban:

```bash
sudo fail2ban-client status sshd
```

Verify SSH:

```bash
sudo sshd -t
```

---

## SSH Lockout Prevention

Before disabling password authentication:

1. Upload public SSH key
2. Verify login with SSH key
3. Open a second SSH session
4. Disable password authentication
5. Restart SSH service
6. Verify access from second session

Never disable password authentication first.

---

## Firewall Deployment Procedure

Apply:

1. Allow SSH
2. Verify SSH access
3. Enable UFW
4. Verify second SSH session
5. Apply remaining rules

Recommended:

```bash
sudo ufw allow 22/tcp
sudo ufw enable
```

---

## Monitoring Exposure Policy

Production Recommendation:

Public:

- 80
- 443

Restricted:

- 3000 (Grafana)
- 9090 (Prometheus)

Internal Only:

- 9100 (Node Exporter)
- 8080 (cAdvisor)

Use VPN, security groups, or reverse proxy authentication.

---

## Backup Security

Backup Directory:

```text
backups/
```

Recommended Permissions:

```bash
chmod 700 backups
```

Backup Files:

```bash
chmod 600 *.sql
```

Only deployment administrators should have access.