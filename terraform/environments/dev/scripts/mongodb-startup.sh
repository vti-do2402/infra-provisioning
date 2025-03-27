#!/bin/bash
# Bastion Host Setup Script for Amazon Linux 2
set -euo pipefail

# Set hostname
sudo hostnamectl set-hostname mongodb

# Update package list
yum update -y

# Setup Docker
yum install -y docker

# Start and enable Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Add ec2-user to docker group
sudo usermod -aG docker ec2-user

# Create data volume
sudo mkdir -p ${var.mongodb.data_volume}
sudo chown -R 999:999 ${var.mongodb.data_volume}

# Install docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/${var.docker_compose_version}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Create docker-compose for MongoDB and Mongo Express
cat <<EOF > /home/ec2-user/docker-compose.yml
services:
  mongodb:
    image: mongo
    ports:
      - "${var.mongodb.port}:27017"
    environment:
      - MONGO_INITDB_ROOT_USERNAME=${var.mongodb.username}
      - MONGO_INITDB_ROOT_PASSWORD=${var.mongodb.password}
    volumes:
      - ${var.mongodb.data_volume}:/data/db

  mongo-express:
    image: mongo-express
    ports:
      - "${var.mongo_express.port}:8081"
    environment:
      - ME_CONFIG_MONGODB_ADMINUSER=${var.mongodb.username}
      - ME_CONFIG_MONGODB_ADMINPASSWORD=${var.mongodb.password}
    depends_on:
      - mongodb

EOF 

# Start MongoDB and Mongo Express
sudo docker-compose up -d

# Print status
echo "MongoDB and Mongo Express are running"

