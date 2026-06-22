# Builder
FROM python:3.12-slim AS builder

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /build

# Install build dependencies for Python packages
RUN apt-get update && \
    apt-get install -y gcc libpq-dev && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install --upgrade pip && \
    pip install --prefix=/install -r requirements.txt

# Runtime
FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=/app

WORKDIR /app

# Install only required runtime libraries
RUN apt-get update && \
    apt-get install -y \
    curl \
    libpq5 && \
    rm -rf /var/lib/apt/lists/*

# Create non-root user for security
RUN groupadd -r pulsefort && \
    useradd -r -m -g pulsefort pulsefort

# Copy installed dependencies from builder stage
COPY --from=builder /install /usr/local

# Copy application source code
COPY app ./app
COPY alembic ./alembic

COPY requirements.txt .
COPY alembic.ini .

COPY scripts ./scripts

# Make scripts executable
RUN chmod +x \
    scripts/entrypoint.sh \
    scripts/healthcheck.sh

# Set correct ownership for application files
RUN chown -R pulsefort:pulsefort /app

USER pulsefort

EXPOSE 8000

# Health check for container monitoring
HEALTHCHECK \
    --interval=30s \
    --timeout=10s \
    --start-period=30s \
    --retries=3 \
    CMD ["/app/scripts/healthcheck.sh"]

# Run database migrations and start application
ENTRYPOINT ["/app/scripts/entrypoint.sh"]