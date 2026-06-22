#!/bin/bash

set -e

echo "Updating packages..."

apt update

apt upgrade -y

echo "Installing packages..."

apt install -y \
ufw \
fail2ban \
curl \
wget \
ca-certificates

echo ""
echo "IMPORTANT"
echo "Verify SSH key login BEFORE disabling password authentication."
echo ""

echo "Applying firewall..."

bash scripts/setup-ufw.sh

echo "Applying Fail2Ban..."

bash scripts/setup-fail2ban.sh

echo ""
echo "Security baseline completed."
echo ""
echo "Verify:"
echo "1. SSH login"
echo "2. Firewall access"
echo "3. Fail2Ban status"