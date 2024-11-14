#!/bin/bash

# Exit the script on any error
set -e

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Ask user input for github token
echo "Please enter your GitHub token:"
read -r GITHUB_TOKEN
export GITHUB_TOKEN

# Update system packages
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install curl if it's not installed
if ! command_exists curl; then
    echo "Installing curl..."
    sudo apt install -y curl
else
    echo "curl is already installed."
fi

# Install K3s if it's not installed
if ! command_exists k3s; then
    echo "Installing K3s with write permissions for KUBECONFIG..."
    curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644

    # Wait until the K3s service is running before proceeding
    echo "Waiting for K3s to be ready..."
    until sudo k3s kubectl get nodes >/dev/null 2>&1; do
        sleep 5
    done

    # Graceful wait for K3s to initialize resources
    echo "Giving K3s time to initialize resources (e.g., coredns, metrics-server)..."
    sleep 60
else
    echo "K3s is already installed."
fi

# Install Flux CLI if it's not installed
if ! command_exists flux; then
    echo "Installing Flux CLI..."
    curl -s https://fluxcd.io/install.sh | sudo bash
else
    echo "Flux CLI is already installed."
fi

# Ensure KUBECONFIG is set and accessible
KUBECONFIG_SRC="/etc/rancher/k3s/k3s.yaml"
KUBECONFIG_DEST="$HOME/.kube/config"

# Check if the KUBECONFIG file exists
if [ ! -f "$KUBECONFIG_SRC" ]; then
    echo "Error: K3s KUBECONFIG file not found."
    exit 1
fi

# Create .kube directory if it doesn't exist
mkdir -p "$HOME/.kube"

# Copy KUBECONFIG to a location accessible by the current user
echo "Copying KUBECONFIG to $HOME/.kube/config..."
sudo cp "$KUBECONFIG_SRC" "$KUBECONFIG_DEST"
sudo chown $(id -u):$(id -g) "$KUBECONFIG_DEST"  # Ensure the current user owns the copied file

# Export KUBECONFIG
echo "Exporting KUBECONFIG..."
export KUBECONFIG="$KUBECONFIG_DEST"

# Verify the kubectl access
echo "Verifying kubectl access..."
kubectl get nodes

# Install Helm if it's not installed
if ! command_exists helm; then
    echo "Installing Helm..."
    curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
else
    echo "Helm is already installed."
fi

# Wait for Kubernetes to be fully ready before bootstrapping Flux
echo "Checking if Kubernetes is ready..."
until kubectl get nodes | grep -E " Ready"; do
    echo "Waiting for all nodes to be ready..."
    sleep 5
done

# Wait until core system pods are running (e.g., kube-system pods)
echo "Waiting for core Kubernetes components to be ready..."
until kubectl get pods -n kube-system | grep -E " Running|Completed" | wc -l | grep -q "$(kubectl get pods -n kube-system --no-headers | wc -l)"; do
    echo "Waiting for core Kubernetes components to be ready..."
    sleep 5
done

# Wait for all containers across all namespaces to be ready
echo "Waiting for all containers to be ready..."
until kubectl get pods --all-namespaces --no-headers | grep -E " Running|Completed" | wc -l | grep -q "$(kubectl get pods --all-namespaces --no-headers | wc -l)"; do
    echo "Waiting for all containers to be ready..."
    sleep 5
done

# Bootstrap Flux
echo "Bootstrapping Flux..."
flux bootstrap github \
  --owner=PierreLapolla \
  --repository=homelab \
  --branch=master \
  --path=clusters/my-cluster \
  --personal=true

unset GITHUB_TOKEN

# Check pods statuses
kubectl get pods --all-namespaces

# FIXME: permission denied on the following command
./info.sh
