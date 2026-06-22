#!/bin/bash

set -e

echo "Installing Fail2Ban"

apt update

apt install -y fail2ban

echo "Deploying configuration"

mkdir -p /etc/fail2ban

cp security/fail2ban/jail.local \
/etc/fail2ban/jail.local

systemctl enable fail2ban

systemctl restart fail2ban

echo "Fail2Ban Status"

fail2ban-client status