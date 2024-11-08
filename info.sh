#!/bin/bash

# Retrieve the Node IP
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')

# Constants
GRAFANA_PORT=32000
GRAFANA_NAMESPACE="grafana"

PIHOLE_WEB_PORT=32001
PIHOLE_DNS_PORT=32002
PIHOLE_NAMESPACE="pihole"

# Verify if Grafana service exists
if kubectl get svc -n "$GRAFANA_NAMESPACE" | grep -q "grafana"; then
  echo "====================================================="
  echo "Grafana is accessible at: http://$NODE_IP:$GRAFANA_PORT"
  echo "====================================================="
else
  echo "Grafana service not found in the '$GRAFANA_NAMESPACE' namespace."
fi

# Verify if Pi-hole service exists
if kubectl get svc -n "$PIHOLE_NAMESPACE" | grep -q "pihole"; then
  echo "====================================================="
  echo "Pi-hole web is accessible at: http://$NODE_IP:$PIHOLE_WEB_PORT/admin"
  echo "Pi-hole DNS is accessible at: $NODE_IP:$PIHOLE_DNS_PORT"
  echo "====================================================="
else
  echo "Pi-hole service not found in the '$PIHOLE_NAMESPACE' namespace."
fi
