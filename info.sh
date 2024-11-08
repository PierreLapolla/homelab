#!/bin/bash

# Retrieve the Node IP
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')

# Constants for Grafana
GRAFANA_PORT=32000
GRAFANA_NAMESPACE="grafana"

# Constants for Pi-hole
PIHOLE_WEB_PORT=32001
PIHOLE_DNS_TCP_PORT=32002
PIHOLE_DNS_UDP_PORT=32003
PIHOLE_DHCP_PORT=32004
PIHOLE_NAMESPACE="pihole"

# Verify if Grafana service exists
if kubectl get svc -n "$GRAFANA_NAMESPACE" | grep -q "grafana"; then
  echo "====================================================="
  echo "Grafana is accessible at: http://$NODE_IP:$GRAFANA_PORT"
  echo "====================================================="
else
  echo "Grafana service not found in the '$GRAFANA_NAMESPACE' namespace."
fi

# Verify if Pi-hole services exist
if kubectl get svc -n "$PIHOLE_NAMESPACE" | grep -q "pihole-web"; then
  echo "====================================================="
  echo "Pi-hole web is accessible at: http://$NODE_IP:$PIHOLE_WEB_PORT/admin"
fi

if kubectl get svc -n "$PIHOLE_NAMESPACE" | grep -q "pihole-dns-tcp"; then
  echo "Pi-hole DNS (TCP) is accessible at: $NODE_IP:$PIHOLE_DNS_TCP_PORT"
fi

if kubectl get svc -n "$PIHOLE_NAMESPACE" | grep -q "pihole-dns-udp"; then
  echo "Pi-hole DNS (UDP) is accessible at: $NODE_IP:$PIHOLE_DNS_UDP_PORT"
fi

if kubectl get svc -n "$PIHOLE_NAMESPACE" | grep -q "pihole-dhcp"; then
  echo "Pi-hole DHCP is accessible at: $NODE_IP:$PIHOLE_DHCP_PORT"
  echo "====================================================="
else
  echo "Pi-hole service not found in the '$PIHOLE_NAMESPACE' namespace."
fi
