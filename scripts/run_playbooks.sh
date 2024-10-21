#!/bin/bash

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