#!/bin/bash

# Update system packages
echo "Updating system packages..."
sudo apt-get update -y
sudo apt-get upgrade -y

# Install required dependencies
echo "Installing required dependencies..."
sudo apt-get install -y python3-pip python3-dev libffi-dev libssl-dev software-properties-common

# Add Ansible PPA and install Ansible
echo "Adding Ansible PPA and installing Ansible..."
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt-get install -y ansible

# Verify Ansible installation
echo "Ansible version:"
ansible --version

echo "Ansible installation complete."
