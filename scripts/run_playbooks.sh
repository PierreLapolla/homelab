#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR=$(dirname "$0")

# Navigate to the root directory of your project
PROJECT_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)

# Run dependencies.yml to install basic dependencies
echo "Running dependencies playbook..."
ansible-playbook -i "$PROJECT_ROOT/ansible/inventory/hosts.ini" "$PROJECT_ROOT/ansible/playbooks/dependencies.yml" || { echo "Failed to run dependencies playbook"; exit 1; }

# Run k3s.yml to install K3s
echo "Running K3s playbook..."
ansible-playbook -i "$PROJECT_ROOT/ansible/inventory/hosts.ini" "$PROJECT_ROOT/ansible/playbooks/k3s.yml" || { echo "Failed to run K3s playbook"; exit 1; }

# Run helm.yml to install Helm
echo "Running Helm playbook..."
ansible-playbook -i "$PROJECT_ROOT/ansible/inventory/hosts.ini" "$PROJECT_ROOT/ansible/playbooks/helm.yml" || { echo "Failed to run Helm playbook"; exit 1; }

# Run prometheus.yml to install Prometheus
echo "Running Prometheus playbook..."
ansible-playbook -i "$PROJECT_ROOT/ansible/inventory/hosts.ini" "$PROJECT_ROOT/ansible/playbooks/prometheus.yml" || { echo "Failed to run Prometheus playbook"; exit 1; }

# Run grafana.yml to install Grafana
echo "Running Grafana playbook..."
ansible-playbook -i "$PROJECT_ROOT/ansible/inventory/hosts.ini" "$PROJECT_ROOT/ansible/playbooks/grafana.yml" || { echo "Failed to run Grafana playbook"; exit 1; }

echo "All playbooks executed successfully!"
