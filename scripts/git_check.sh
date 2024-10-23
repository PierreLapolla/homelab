#!/bin/bash

# Check if Git is installed
if ! command -v git &> /dev/null; then
  echo "Git is not installed. Installing Git..."
  sudo apt-get update -y
  sudo apt-get install -y git || { echo "Failed to install Git"; exit 1; }
  echo "Git has been successfully installed."
else
  echo "Git is already installed."
fi

# Define GitHub repository details (can be passed as arguments or environment variables)
USERNAME="${1:-PierreLapolla}"  # Default to PierreLapolla if not provided
REPO_NAME="${2:-homelab}"       # Default to homelab if not provided
REPO_URL="https://github.com/${USERNAME}/${REPO_NAME}.git"

# Check if repository is already cloned
if [ ! -d "$REPO_NAME" ]; then
  echo "Cloning the repository..."
  git clone "$REPO_URL" || { echo "Failed to clone repository"; exit 1; }
  cd "$REPO_NAME"
else
  echo "Repository already exists, pulling latest changes..."
  cd "$REPO_NAME" && git pull || { echo "Failed to pull latest changes"; exit 1; }
fi
