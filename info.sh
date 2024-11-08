#!/bin/bash

# Retrieve the Node IP
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')

# Constants for Grafana
GRAFANA_NAMESPACE="grafana"
GRAFANA_PORT=$(kubectl get svc -n "$GRAFANA_NAMESPACE" grafana -o jsonpath='{.spec.ports[0].nodePort}')

# Pi-hole Namespace
PIHOLE_NAMESPACE="pihole"

# Retrieve Pi-hole service ports dynamically
PIHOLE_WEB_PORT=$(kubectl get svc -n "$PIHOLE_NAMESPACE" pihole-web -o jsonpath='{.spec.ports[0].nodePort}')
PIHOLE_DNS_TCP_PORT=$(kubectl get svc -n "$PIHOLE_NAMESPACE" pihole-dns-tcp -o jsonpath='{.spec.ports[0].nodePort}')
PIHOLE_DNS_UDP_PORT=$(kubectl get svc -n "$PIHOLE_NAMESPACE" pihole-dns-udp -o jsonpath='{.spec.ports[0].nodePort}')
PIHOLE_DHCP_PORT=$(kubectl get svc -n "$PIHOLE_NAMESPACE" pihole-dhcp -o jsonpath='{.spec.ports[0].nodePort}')

# Verify if Grafana service exists
if kubectl get svc -n "$GRAFANA_NAMESPACE" | grep -q "grafana"; then
  echo "====================================================="
  echo "Grafana is accessible at: http://$NODE_IP:$GRAFANA_PORT"
  echo "====================================================="
else
  echo "Grafana service not found in the '$GRAFANA_NAMESPACE' namespace."
fi

# Verify if Pi-hole services exist and display them dynamically
echo "====================================================="
if [ -n "$PIHOLE_WEB_PORT" ]; then
  echo "Pi-hole web is accessible at: http://$NODE_IP:$PIHOLE_WEB_PORT/admin"
else
  echo "Pi-hole web service not found in the '$PIHOLE_NAMESPACE' namespace."
fi

if [ -n "$PIHOLE_DNS_TCP_PORT" ]; then
  echo "Pi-hole DNS (TCP) is accessible at: $NODE_IP:$PIHOLE_DNS_TCP_PORT"
else
  echo "Pi-hole DNS (TCP) service not found in the '$PIHOLE_NAMESPACE' namespace."
fi

if [ -n "$PIHOLE_DNS_UDP_PORT" ]; then
  echo "Pi-hole DNS (UDP) is accessible at: $NODE_IP:$PIHOLE_DNS_UDP_PORT"
else
  echo "Pi-hole DNS (UDP) service not found in the '$PIHOLE_NAMESPACE' namespace."
fi

if [ -n "$PIHOLE_DHCP_PORT" ]; then
  echo "Pi-hole DHCP is accessible at: $NODE_IP:$PIHOLE_DHCP_PORT"
else
  echo "Pi-hole DHCP service not found in the '$PIHOLE_NAMESPACE' namespace."
fi
echo "====================================================="
