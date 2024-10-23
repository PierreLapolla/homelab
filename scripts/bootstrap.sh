#!/bin/bash

# Check for and kill any hanging apt/dpkg processes
echo "Checking for existing apt locks..."
sudo kill -9 $(ps aux | grep '[a]pt' | awk '{print $2}') 2>/dev/null
sudo kill -9 $(ps aux | grep '[d]pkg' | awk '{print $2}') 2>/dev/null

# Remove apt/dpkg lock files if present
sudo rm /var/lib/dpkg/lock
sudo rm /var/lib/apt/lists/lock
sudo rm /var/cache/apt/archives/lock

# Run the git_check.sh script
echo "Running git check script..."
bash scripts/git_check.sh || { echo "Git check failed"; exit 1; }

# Run the setup script to install Ansible (if not already done)
echo "Running setup script..."
bash scripts/setup.sh || { echo "Setup script failed"; exit 1; }

# Run the playbooks to install
echo "Running Ansible playbooks..."
bash scripts/run_playbooks.sh || { echo "Playbooks execution failed"; exit 1; }

echo "Bootstrap completed successfully!"
