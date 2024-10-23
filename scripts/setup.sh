#!/bin/bash

# Exit on error
set -e

# Redirect output to a log file for debugging
exec > >(tee -i setup.log)
exec 2>&1

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Check if Ansible is already installed
if command_exists ansible; then
    echo "Ansible is already installed."
else
    # Update system packages only if Ansible isn't installed
    echo "Updating system packages..."
    sudo apt-get update -y

    # Install required dependencies
    echo "Installing required dependencies..."
    sudo apt-get install -y python3-pip python3-dev libffi-dev libssl-dev software-properties-common curl

    # Add Ansible PPA and install Ansible
    echo "Adding Ansible PPA and installing Ansible..."
    sudo apt-add-repository --yes --update ppa:ansible/ansible
    sudo apt-get install -y ansible

    # Verify Ansible installation
    echo "Ansible version:"
    ansible --version
fi

# Install Ansible collections and roles from requirements.yml
echo "Installing required Ansible collections and roles..."
ansible-galaxy install -r ansible/requirements.yml || { echo "Failed to install required collections and roles"; exit 1; }

echo "Ansible setup and collection/role installation complete."
