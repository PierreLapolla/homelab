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
