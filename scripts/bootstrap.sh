#!/bin/bash

# Run git_install.sh to ensure Git is installed
bash scripts/git_install.sh

# Define your GitHub repository details
USERNAME="PierreLapolla"      # Replace with your GitHub username
REPO_NAME="homelab"           # Replace with your repository name
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

# Run the playbooks to install
echo "Running Ansible playbooks..."
bash scripts/run_playbooks.sh
