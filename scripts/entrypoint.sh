#!/bin/sh

set -e

echo "Waiting for PostgreSQL"

until python - <<EOF
from sqlalchemy import create_engine
from app.db.session import DATABASE_URL

engine = create_engine(DATABASE_URL)

with engine.connect():
    pass
EOF
do
    echo "PostgreSQL not ready"
    sleep 3
done

echo "PostgreSQL ready."

echo "Waiting for Redis"

until python - <<EOF
from app.db.redis import redis_client

redis_client.ping()
EOF
do
    echo "Redis not ready"
    sleep 3
done

echo "Redis ready."

echo "Running Alembic migrations"

alembic upgrade head

echo "Starting PulseFort"

exec uvicorn app.main:app \
    --host 0.0.0.0 \
    --port 8000