#!/bin/bash
# Bastion Host Setup Script for Amazon Linux 2
set -euo pipefail

# Set hostname
sudo hostnamectl set-hostname mongodb

# Update package list
sudo dnf update -y

sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
sudo dnf -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin
# Add ec2-user to docker group
sudo usermod -aG docker ec2-user
sudo chmod 666 /var/run/docker.sock

# Start and enable docker service
sudo systemctl start docker
sudo systemctl enable docker

# Create a directory for the volumes
sudo mkdir -p ${DATA_VOLUME}
sudo chown -R ec2-user:ec2-user ${DATA_VOLUME}

# Create docker compose file
cat <<EOF > /home/ec2-user/docker-compose.yml
services:
    mongo:
        image: mongo
        restart: unless-stopped
        ports:
            - "27017:27017"
        environment:
            - MONGO_INITDB_ROOT_USERNAME=${MONGODB_ADMIN_USERNAME}
            - MONGO_INITDB_ROOT_PASSWORD=${MONGODB_ADMIN_PASSWORD}
        volumes:
            - ${DATA_VOLUME}:/data/db
EOF

# Run docker compose
docker compose up -d
echo "MongoDB is running"

