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

# Define GitHub repository details
USERNAME="PierreLapolla"
REPO_NAME="homelab"
REPO_URL="https://github.com/${USERNAME}/${REPO_NAME}.git"

# Get the directory where the script is located
SCRIPT_DIR=$(dirname "$0")

# Navigate to the project root (assuming the script is in homelab/scripts/)
PROJECT_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)

# Check if we're already inside the repository
if [ "$(basename "$PWD")" == "$REPO_NAME" ]; then
    echo "Already inside the repository directory, pulling latest changes..."
    git pull || { echo "Failed to pull latest changes"; exit 1; }
else
    # Clone the repository if it doesn't exist
    if [ ! -d "$PROJECT_ROOT/$REPO_NAME" ]; then
        echo "Cloning the repository..."
        git clone "$REPO_URL" "$PROJECT_ROOT/$REPO_NAME" || { echo "Failed to clone repository"; exit 1; }
        cd "$PROJECT_ROOT/$REPO_NAME"
    else
        echo "Repository already exists, pulling latest changes..."
        cd "$PROJECT_ROOT/$REPO_NAME" && git pull || { echo "Failed to pull latest changes"; exit 1; }
    fi
fi
