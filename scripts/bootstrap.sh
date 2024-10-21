#!/bin/bash

# Define your GitHub repository details
USERNAME="PierreLapolla"      # Replace with your GitHub username
REPO_NAME="homelab" # Replace with your repository name
REPO_URL="https://github.com/${USERNAME}/${REPO_NAME}.git"

# Get the current working directory
CURRENT_DIR=$(pwd)

# Check if we're already inside the repository
if [[ "$CURRENT_DIR" != *"$REPO_NAME"* ]]; then
  # Clone the repository if it doesn't already exist
  if [ ! -d "$REPO_NAME" ]; then
    echo "Cloning the repository..."
    git clone "$REPO_URL"
    cd "$REPO_NAME"
  else
    echo "Repository already exists, pulling latest changes..."
    cd "$REPO_NAME" && git pull
  fi
else
  echo "Already inside the repository directory, pulling latest changes..."
  git pull
fi

# Run the setup script to install Ansible (if not already done)
echo "Running setup script..."
bash scripts/setup.sh

# Run the playbooks to install dependencies, K3s, and Helm
# Ensure playbooks are run from the correct directory

# Run dependencies.yml to install basic dependencies
echo "Running dependencies playbook..."
ansible-playbook playbooks/dependencies.yml || { echo "Failed to run dependencies playbook"; exit 1; }

# Run k3s.yml to install K3s
echo "Running K3s playbook..."
ansible-playbook playbooks/k3s.yml || { echo "Failed to run K3s playbook"; exit 1; }

# Run helm.yml to install Helm
echo "Running Helm playbook..."
ansible-playbook playbooks/helm.yml || { echo "Failed to run Helm playbook"; exit 1; }

echo "All playbooks executed successfully!"
