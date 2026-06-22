#!/bin/bash

set -e

echo "Resetting UFW"

ufw --force reset

echo "Default policies"

ufw default deny incoming
ufw default allow outgoing

echo "Allowing SSH"
ufw allow 22/tcp

echo "Allowing HTTP"
ufw allow 80/tcp

echo "Allowing HTTPS"
ufw allow 443/tcp

echo "Enabling UFW"

ufw --force enable

echo "Firewall status"

ufw status verbose