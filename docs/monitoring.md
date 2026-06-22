# PulseFort Monitoring Guide

## Monitoring Stack

PulseFort uses:

- Prometheus
- Grafana
- Node Exporter
- cAdvisor

---

## Architecture

```text
FastAPI
   |
   v
Prometheus
   |
   v
Grafana

Node Exporter ---> Prometheus
cAdvisor -------> Prometheus
```

---

## Prometheus

URL:

```text
http://SERVER_IP:9090
```

Purpose:

- Application Metrics
- Container Metrics
- Host Metrics

Configured Targets:

- pulsefort-app
- prometheus
- node-exporter
- cadvisor

---

## Grafana

URL:

```text
http://SERVER_IP:3000
```

Credentials:

```text
Configured via environment variables
```

Environment Variables:

```env
GRAFANA_ADMIN_USER
GRAFANA_ADMIN_PASSWORD
```

---

## Dashboard

Default Dashboard:

```text
PulseFort Overview
```

Metrics Included:

- Application Availability
- Container Count
- CPU Usage
- Memory Usage
- Network RX
- Network TX

---

## Node Exporter

Purpose:

Host-level metrics.

Endpoint:

```text
http://SERVER_IP:9100/metrics
```

Recommended:

Restrict access to internal networks.

---

## cAdvisor

Purpose:

Container metrics.

Endpoint:

```text
http://SERVER_IP:8080
```

Recommended:

Restrict access to internal networks.

---

## Prometheus Validation

Open:

```text
Status -> Targets
```

Expected:

```text
UP
UP
UP
UP
```

---

## Grafana Validation

Verify:

- Datasource connected
- Dashboard loads
- Metrics visible

---

## Troubleshooting

### Target Down

Check:

```bash
docker compose ps
```

Then:

```bash
docker compose logs <service>
```

---

### No Metrics

Verify:

```bash
curl http://localhost/metrics
```

---

### Grafana Cannot Connect

Verify:

```bash
docker compose logs grafana
docker compose logs prometheus
```