#!/bin/bash

# Define your GitHub repository details
USERNAME="PierreLapolla"      # Replace with your GitHub username
REPO_NAME="homelab" # Replace with your repository name
REPO_URL="https://github.com/${USERNAME}/${REPO_NAME}.git"

# Clone the repository if it doesn't already exist
if [ ! -d "$REPO_NAME" ]; then
  echo "Cloning the repository..."
  git clone "$REPO_URL"
else
  echo "Repository already exists, pulling latest changes..."
  cd "$REPO_NAME" && git pull
fi

# Change into the cloned repository directory
cd "$REPO_NAME"

# Run the setup script to install Ansible (if not already done)
echo "Running setup script..."
bash scripts/setup.sh

# Run dependencies.yml to install basic dependencies
echo "Running dependencies playbook..."
ansible-playbook playbooks/dependencies.yml

# Run k3s.yml to install K3s
echo "Running K3s playbook..."
ansible-playbook playbooks/k3s.yml

# Run helm.yml to install Helm
echo "Running Helm playbook..."
ansible-playbook playbooks/helm.yml