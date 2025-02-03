#!/usr/bin/bash

# SSH Agent
# eval $(ssh-agent)
# ssh-add

# Create ssh directory
mkdir -p $HOME/.ssh
chmod 700 $HOME/.ssh

# Sync repos
sudo apt update

# Update packages
sudo apt full-upgrade -y

# Install base packages
sudo apt install -y \
    zstd \
    unzip

# Install python's venv
sudo apt install -y python3-venv

# Install and source nfm
curl -o- https://fnm.vercel.app/install | bash
source /home/zero/.bashrc

# Install latest Node LTS
fnm install --lts

################################################
##### Docker
################################################

# References:
# https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository

# Install dependencies
sudo apt install -y ca-certificates curl

# Configure keyring
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update

# Install Docker
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Create docker group
sudo groupadd docker

# Add user to docker group
sudo usermod -aG docker $USER
newgrp docker