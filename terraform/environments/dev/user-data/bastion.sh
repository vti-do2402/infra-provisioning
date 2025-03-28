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
if ! command -v aws &> /dev/null; then
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
export KUBECTL_VERSION="1.31.3"
export KUBECTL_RELEASE_DATE="2024-12-12"
export ARCH=amd64

curl -o kubectl "https://s3.us-west-2.amazonaws.com/amazon-eks/${KUBECTL_VERSION}/${KUBECTL_RELEASE_DATE}/bin/linux/${ARCH}/kubectl"
curl -o kubectl.sha256 "https://s3.us-west-2.amazonaws.com/amazon-eks/${KUBECTL_VERSION}/${KUBECTL_RELEASE_DATE}/bin/linux/${ARCH}/kubectl.sha256"

echo "$(cat kubectl.sha256) kubectl" | sha -a 256 -c

chmod +x kubectl
sudo mv kubectl /usr/local/bin/kubectl
rm kubectl.sha256

#-------------------------------
# Install eksctl
#-------------------------------
export PLATFORM="$(uname -s)_$ARCH"

curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_${PLATFORM}.tar.gz"
curl -sL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_checksums.txt" | grep "${PLATFORM}" |  sha -a 256 -c

tar -xzf "eksctl_${PLATFORM}.tar.gz" -C /tmp
sudo mv /tmp/eksctl /usr/local/bin/
rm "eksctl_${PLATFORM}.tar.gz"

#-------------------------------
# Final Touch
#-------------------------------
echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc
echo "✅ Setup complete for Bastion Host on Ubuntu 24.04 LTS"
