# Monitoring Guide

## Overview

PulseFort includes a production-oriented monitoring stack that provides visibility into application health, infrastructure performance, container utilization, and service availability.

The platform combines Prometheus, Grafana, Node Exporter, and cAdvisor to deliver centralized observability across the entire environment.

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

---

## Monitoring Components

| Component     | Purpose                    |
| ------------- | -------------------------- |
| Prometheus    | Metrics Collection         |
| Grafana       | Dashboards & Visualization |
| Node Exporter | Host Monitoring            |
| cAdvisor      | Container Monitoring       |

---

## Service Access

### Grafana

```text
https://SERVER_IP/grafana/
```

Used for dashboard visualization, infrastructure monitoring, and operational analysis.

### Prometheus

```text
https://SERVER_IP/prometheus/
```

Used for metrics collection, target validation, and query execution.

Both services are exposed securely through NGINX over HTTPS.

---

## Metrics Sources

### FastAPI

Application metrics exposed through:

```text
/metrics
```

Metrics include:

* Request activity
* Endpoint usage
* Service availability
* Application health

### Node Exporter

Host-level metrics including:

* CPU utilization
* Memory usage
* Disk utilization
* Network statistics
* System load

### cAdvisor

Container-level metrics including:

* CPU consumption
* Memory consumption
* Network activity
* Filesystem usage
* Container lifecycle data

---

## Dashboard Overview

The default PulseFort dashboard provides visibility into:

* Prometheus Targets
* Application Availability
* Host CPU Usage
* Host Memory Usage
* Container CPU Usage
* Container Memory Usage
* Network Traffic
* Container Statistics

---

## Validation Checks

### Verify Prometheus Targets

Open:

```text
https://SERVER_IP/prometheus/targets
```

Expected targets:

```text
pulsefort-app    UP
prometheus       UP
node-exporter    UP
cadvisor         UP
```

### Verify Grafana

Confirm:

* Dashboard loads successfully
* Prometheus datasource is connected
* Metrics are displayed
* Panels update in real time

### Verify Application Metrics

```bash
curl http://localhost/metrics
```

Expected: Prometheus-formatted metrics output.

---

## Operational Commands

### Check Services

```bash
docker compose ps
```

### View Monitoring Logs

```bash
docker compose logs prometheus
docker compose logs grafana
```

### Verify Health

```bash
curl http://localhost/health
curl http://localhost/ready
```

---

## Troubleshooting

### Target Down

```bash
docker compose ps
docker compose logs <service>
```

### Missing Metrics

```bash
curl http://localhost/metrics
```

Verify Prometheus target configuration and scrape status.

### Empty Grafana Panels

* Verify Prometheus targets are UP
* Check dashboard time range
* Confirm datasource connectivity

### Monitoring Services Unavailable

```bash
docker compose restart prometheus grafana
```

---

## Benefits

* Centralized observability
* Real-time monitoring
* Deployment validation
* Infrastructure visibility
* Container resource tracking
* Faster troubleshooting

---

PulseFort uses Prometheus, Grafana, Node Exporter, and cAdvisor to provide end-to-end observability for application, infrastructure, and container workloads through a secure HTTPS-based monitoring architecture.
