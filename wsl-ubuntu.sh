#!/usr/bin/bash

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