#!/bin/bash

# Check if Git is installed
if ! command -v git &> /dev/null; then
  echo "Git is not installed. Installing Git..."
  sudo apt-get update -y
  sudo apt-get install -y git
  echo "Git has been successfully installed."
else
  echo "Git is already installed."
fi

# Define your GitHub repository details
USERNAME="PierreLapolla"      # Replace with your GitHub username
REPO_NAME="homelab"           # Replace with your repository name
REPO_URL="https://github.com/${USERNAME}/${REPO_NAME}.git"

# Get the current working directory
CURRENT_DIR=$(pwd)

# Check if we're already inside the repository
if [[ "$CURRENT_DIR" != *"$REPO_NAME"* ]]; then
  # Clone the repository if it doesn't already exist
  if [ ! -d "$REPO_NAME" ]; then
    echo "Cloning the repository..."
    git clone "$REPO_URL"
    cd "$REPO_NAME"
  else
    echo "Repository already exists, pulling latest changes..."
    cd "$REPO_NAME" && git pull
  fi
else
  echo "Already inside the repository directory, pulling latest changes..."
  git pull
fi