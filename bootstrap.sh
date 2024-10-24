#!/bin/bash

# Update system packages
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install K3s
echo "Installing K3s..."
curl -sfL https://get.k3s.io | sh -

# Wait for K3s to be ready
sleep 60

# Install Flux CLI
echo "Installing Flux CLI..."
curl -s https://fluxcd.io/install.sh | sudo bash

# Export KUBECONFIG
echo "Exporting KUBECONFIG..."
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

# Install Helm
echo "Installing Helm..."
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

# Install Git
echo "Installing Git..."
sudo apt install git -y

# Bootstrap Flux
echo "Bootstrapping Flux..."
flux bootstrap github \
  --owner=PierreLapolla \
  --repository=homelab \
  --branch=main \
  --path=clusters/my-cluster \
  --personal

# Creating ssh key and print content to console
echo "Creating SSH key..."
ssh-keygen -t ed25519 -C "plapolla9@gmail.com"
cat ~/.ssh/id_ed25519.pub
