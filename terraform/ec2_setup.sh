#!/bin/bash
# Update and upgrade system packages
sudo apt-get update -y
sudo apt-get upgrade -y

# Install Docker
sudo apt-get install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker

# Add the default user to the docker group to run Docker commands without sudo
sudo usermod -aG docker $USER
sudo usermod -aG docker ubuntu

# Set proper permissions for Docker socket
sudo chmod 666 /var/run/docker.sock

# Install AWS CLI
sudo apt-get update -y
sudo apt-get install -y unzip curl
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
rm -rf awscliv2.zip aws

# Initialize Docker Swarm (required for managing containers across multiple hosts)
docker swarm init

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Make Docker Compose executable
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Display Docker and Docker Compose versions to verify installation
docker --version
docker-compose --version
