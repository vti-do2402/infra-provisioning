#!/bin/bash
# Bastion Host Setup Script for Amazon Linux 2
set -euo pipefail

# Set hostname
sudo hostnamectl set-hostname mongodb

# Update package list
sudo yum update -y

# Setup Docker
sudo yum install -y docker

# Start and enable Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Add ec2-user to docker group
sudo usermod -aG docker ec2-user
sudo chmod 666 /var/run/docker.sock


docker run -d --name mongo-express -p 8081:8081 -e ME_CONFIG_MONGODB_SERVER=mongodb mongo-express
docker run -d --name mongodb -p 27017:27017 mongo

# Print status
echo "MongoDB and Mongo Express are running"

