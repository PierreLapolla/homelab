#!/bin/bash

# Run the setup script to install Ansible (if not already done)
echo "Running setup script..."
bash scripts/setup.sh

# Run the playbooks to install
echo "Running Ansible playbooks..."
bash scripts/run_playbooks.sh
