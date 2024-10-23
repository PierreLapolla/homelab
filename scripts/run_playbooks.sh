#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR=$(dirname "$0")

# Navigate to the root directory of your project
PROJECT_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)

# Define an array of playbooks to run
playbooks=("dependencies.yml" "k3s.yml" "helm.yml" "prometheus.yml" "grafana.yml")

# Loop through each playbook and run it
for playbook in "${playbooks[@]}"; do
  echo "Running $playbook playbook..."
  ansible-playbook -i "$PROJECT_ROOT/ansible/inventory/hosts.ini" "$PROJECT_ROOT/ansible/playbooks/$playbook" || {
    echo "Failed to run $playbook playbook"
    exit 1
  }
done

echo "All playbooks executed successfully!"
