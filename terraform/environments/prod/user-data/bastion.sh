#!/bin/bash
# Bastion Host Setup Script for Ubuntu 24.04 LTS

set -euo pipefail

# Set hostname
sudo hostnamectl set-hostname bastion

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
if ! command -v aws &> /dev/null ; then
  echo "Installing AWS CLI..."
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install
  rm -rf aws awscliv2.zip
else
  echo "AWS CLI already installed."
fi

#-------------------------------
# Install kubectl for EKS (v1.31.3)
#-------------------------------

curl -o kubectl "https://s3.us-west-2.amazonaws.com/amazon-eks/${KUBECTL_VERSION}/${KUBECTL_RELEASE_DATE}/bin/linux/${ARCH}/kubectl"
curl -o kubectl.sha256 "https://s3.us-west-2.amazonaws.com/amazon-eks/${KUBECTL_VERSION}/${KUBECTL_RELEASE_DATE}/bin/linux/${ARCH}/kubectl.sha256"

echo "$(cat kubectl.sha256) kubectl" | sha256sum -c kubectl.sha256

chmod +x kubectl
sudo mv kubectl /usr/local/bin/kubectl
rm kubectl.sha256

#-------------------------------
# Final Touch
#-------------------------------
echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc
echo "✅ Setup complete for Bastion Host on Ubuntu 24.04 LTS"
