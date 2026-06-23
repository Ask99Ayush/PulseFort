# Monitoring Guide

## Overview

Observability is a core component of PulseFort. The platform includes a full monitoring stack that provides visibility into application performance, infrastructure health, container resource usage, and service availability.

The monitoring architecture enables engineers to validate deployments, troubleshoot incidents, monitor resource utilization, and maintain operational awareness across the platform.

---

## Monitoring Stack

| Component     | Purpose                      |
|---------------|------------------------------|
| Prometheus    | Metrics collection & storage |
| Grafana       | Visualization & dashboards   |
| Node Exporter | Host-level metrics           |
| cAdvisor      | Container-level metrics      |

---

## Monitoring Architecture

```
FastAPI       ──► Prometheus ──► Grafana
Node Exporter ──► Prometheus
cAdvisor      ──► Prometheus
```

Metrics from multiple sources are aggregated by Prometheus and visualized in Grafana.

---

## Prometheus

Central metrics collection and storage engine.

**Access**

```
Internal Docker service (http://prometheus:9090)
```

**Monitored Targets**

```
pulsefort-app
prometheus
node-exporter
cadvisor
```

**Application Metrics** — collected from `/metrics`

- HTTP request volume
- Endpoint activity
- Request latency
- Service availability

**Host Metrics** — collected via Node Exporter

- CPU usage
- Memory utilization
- Disk usage
- Network statistics

**Container Metrics** — collected via cAdvisor

- Container CPU and memory
- Network utilization
- Filesystem usage
- Container lifecycle events

---

## Grafana

Dashboard and visualization platform for collected metrics.

**Access**

```
https://SERVER_IP/grafana/
```

**Authentication** — configured through environment variables

```
GRAFANA_ADMIN_USER
GRAFANA_ADMIN_PASSWORD
```

Use strong credentials for all production deployments.

**Default Dashboard: PulseFort Overview**

Infrastructure panels:

- CPU utilization
- Memory consumption
- Disk usage
- Network throughput

Container panels:

- Container count and status
- Resource utilization
- Container availability

Application panels:

- Request volume
- Service health
- Endpoint activity

---

## Node Exporter

Provides host-level metrics from the EC2 operating system.

**Endpoint**

```
Internal only (Node Exporter)
```

**Metrics Collected**

- CPU utilization and load
- Memory usage and availability
- Disk and filesystem statistics
- Network traffic and interface activity

Node Exporter should be accessible only from internal monitoring systems. Public exposure is not recommended.

---

## cAdvisor

Provides container resource consumption and runtime visibility.

**Endpoint**

```
Internal only (cAdvisor)
```

**Metrics Collected**

- Container CPU and memory usage
- Filesystem and network utilization
- Container state and uptime
- Resource pressure and utilization trends

cAdvisor should remain internal and should not be exposed publicly.

---

## Validation Procedures

Run after every deployment.

**Prometheus — verify targets**

```
Internal Docker service (http://prometheus:9090) → Status → Targets
```

All configured targets should report `UP`.

**Grafana — verify dashboards**

- Grafana loads successfully
- Prometheus datasource is connected
- Dashboards render with data

**Application metrics**

```bash
curl http://localhost/metrics
```

Expected: Prometheus-formatted metrics output.

---

## Common Monitoring Workflows

**Verify service availability**

```bash
curl http://localhost/health
curl http://localhost/ready
```

**Check running containers**

```bash
docker compose ps
```

**Review monitoring logs**

```bash
docker compose logs prometheus
docker compose logs grafana
docker compose logs node-exporter
docker compose logs cadvisor
```

---

## Troubleshooting

**Target reported as DOWN**

```bash
docker compose ps
docker compose logs <service>
```

Investigate container health and network connectivity.

**No metrics available**

```bash
curl http://localhost/metrics
```

Check Prometheus target configuration under Status → Targets.

**Grafana cannot connect to Prometheus**

```bash
docker compose logs grafana
docker compose logs prometheus
```

Verify Prometheus is running and the datasource URL is correctly configured.

**Missing dashboard data**

- Confirm Prometheus targets are UP
- Verify time range selection
- Confirm datasource is connected

---

## Operational Benefits

- Centralized visibility across infrastructure and application
- Faster troubleshooting with targeted metrics
- Deployment validation through health and readiness checks
- Capacity planning and performance analysis
- Container health and service availability monitoring

---

## Conclusion

PulseFort's monitoring stack combines Prometheus, Grafana, Node Exporter, and cAdvisor to deliver comprehensive observability across application, infrastructure, and container layers. By integrating metrics collection, visualization, validation, and troubleshooting workflows, the platform provides the observability foundation required for reliable production operations.