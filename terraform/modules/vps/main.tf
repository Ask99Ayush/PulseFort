resource "aws_instance" "pulsefort" {

  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id = var.subnet_id

  key_name = var.key_name

  vpc_security_group_ids = [
    var.security_group_id
  ]

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
    encrypted   = true
  }

  user_data = <<-EOF
#!/bin/bash
set -eux

apt-get update -y
apt-get upgrade -y

apt-get install -y \
  curl \
  git \
  unzip \
  wget \
  ca-certificates \
  gnupg \
  lsb-release \
  software-properties-common \
  ufw \
  fail2ban

install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
gpg --dearmor -o /etc/apt/keyrings/docker.gpg

chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update -y

apt-get install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin

systemctl enable docker
systemctl start docker

usermod -aG docker ubuntu || true

mkdir -p /opt/pulsefort

chown ubuntu:ubuntu /opt/pulsefort

systemctl enable fail2ban
systemctl start fail2ban

docker --version > /var/log/pulsefort-bootstrap.log
docker compose version >> /var/log/pulsefort-bootstrap.log
git --version >> /var/log/pulsefort-bootstrap.log

echo "PulseFort bootstrap completed" >> /var/log/pulsefort-bootstrap.log

EOF

  tags = {
    Name        = "pulsefort-server"
    Project     = "PulseFort"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}

resource "aws_eip" "pulsefort" {

  domain = "vpc"

  instance = aws_instance.pulsefort.id

  tags = {
    Name        = "pulsefort-eip"
    Project     = "PulseFort"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}