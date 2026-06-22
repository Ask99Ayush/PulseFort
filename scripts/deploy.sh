#!/bin/bash

set -e

APP_DIR="/opt/pulsefort"

cd "${APP_DIR}"

echo "Creating rollback point..."

CURRENT_IMAGE=$(docker image ls pulsefort --format "{{.Repository}}:{{.Tag}}" | head -n 1 || true)

echo "Pulling latest code..."

git fetch origin

git reset --hard origin/main

echo "Pulling latest image..."

docker compose pull

echo "Deploying..."

docker compose up -d

echo "Waiting for startup..."

sleep 30

echo "Running readiness verification..."

if curl -fsS http://localhost/ready > /dev/null
then
    echo "Deployment successful."
    exit 0
fi

echo "Deployment failed."

if [ -n "$CURRENT_IMAGE" ]
then
    echo "Rollback information available:"
    echo "$CURRENT_IMAGE"
fi

exit 1