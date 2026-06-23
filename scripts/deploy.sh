#!/bin/bash

set -e

APP_DIR="/opt/pulsefort"

cd "${APP_DIR}"

echo "Creating rollback point..."

git branch rollback-$(date +%Y%m%d-%H%M%S) >/dev/null 2>&1 || true

echo "Pulling latest code..."

git fetch origin

git reset --hard origin/main

echo "Building application image..."

docker compose build

echo "Deploying services..."

docker compose up -d

echo "Waiting for startup..."

sleep 30

echo "Running readiness verification..."

if curl -fsS http://localhost/ready > /dev/null
then
echo "Deployment successful."
docker image prune -f
exit 0
fi

echo "Deployment failed."

echo "Container status:"
docker compose ps

echo "Recent logs:"
docker compose logs --tail=100

exit 1
