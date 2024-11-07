#!/bin/bash

# Retrieve the Node IP
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')

# Check if Grafana is installed and accessible
GRAFANA_PORT=30000
GRAFANA_NAMESPACE="grafana"

# Verify if Grafana service exists
if kubectl get svc -n "$GRAFANA_NAMESPACE" | grep -q "grafana"; then
  echo "====================================================="
  echo "Grafana is accessible at: http://$NODE_IP:$GRAFANA_PORT"
  echo "====================================================="
else
  echo "Grafana service not found in the '$GRAFANA_NAMESPACE' namespace."
fi
