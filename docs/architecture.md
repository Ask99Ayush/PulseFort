# PulseFort Architecture

## High-Level Architecture

```text
                Internet
                    |
                    v
              +-----------+
              |   NGINX   |
              +-----------+
                    |
                    v
              +-----------+
              |  FastAPI  |
              +-----------+
               |         |
               v         v
        +----------+  +--------+
        |PostgreSQL|  | Redis  |
        +----------+  +--------+

                    |
                    v

             Monitoring Stack

     +-------------+-------------+
     |             |             |
     v             v             v

Prometheus   Node Exporter   cAdvisor
     |
     v
 Grafana
```

---

## Components

### FastAPI

Provides:

- User CRUD
- Cache API
- Metrics Endpoint

### PostgreSQL

Primary persistent datastore.

### Redis

Caching layer.

### NGINX

Handles:

- Reverse Proxy
- Rate Limiting
- Security Headers

### Prometheus

Metrics collection.

### Grafana

Visualization.

### Terraform

Infrastructure provisioning.

### GitHub Actions

Deployment automation.