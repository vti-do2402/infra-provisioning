#!/bin/bash

set -euo pipefail

# Set hostname
sudo hostnamectl set-hostname github-runner

# Update system
sudo apt-get update -y
sudo apt-get install -y \
    curl \
    unzip \
    git \
    ca-certificates \
    gnupg \
    lsb-release

#-------------------------------
# Install AWS CLI v2
#-------------------------------
if ! command -v aws &> /dev/null; then
  echo "Installing AWS CLI..."
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install
  rm -rf aws awscliv2.zip
else
  echo "AWS CLI already installed."
fi

cd /home/ubuntu

mkdir actions-runner && cd actions-runner
curl -o actions-runner-linux-x64-2.323.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.323.0/actions-runner-linux-x64-2.323.0.tar.gz
echo "0dbc9bf5a58620fc52cb6cc0448abcca964a8d74b5f39773b7afcad9ab691e19  actions-runner-linux-x64-2.323.0.tar.gz" | shasum -a 256 -c
tar xzf ./actions-runner-linux-x64-2.323.0.tar.gz

# ./config.sh --url https://github.com/vti-do2402/infra-provisioning --token BJ5O6AJT5QLJ2M77IWIAOK3H4BB3M
# ./run.sh