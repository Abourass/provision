#!/usr/bin/env bash

set -e

echo "======================================"
echo "  Provision - Quick Setup"
echo "======================================"
echo ""

# Check if running on Debian-based system
if ! command -v apt &> /dev/null; then
    echo "Error: This script requires a Debian-based system (apt package manager)"
    exit 1
fi

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Install git if not present
if command_exists git; then
    echo "✓ git already installed"
else
    echo "→ Installing git..."
    sudo apt update
    sudo apt install -y git
fi

# Define installation directory
INSTALL_DIR="$HOME/provision"

# Clone or update repository
if [ -d "$INSTALL_DIR" ]; then
    echo ""
    echo "→ Directory $INSTALL_DIR already exists"
    echo "→ Pulling latest changes..."
    cd "$INSTALL_DIR"
    git pull
else
    echo ""
    echo "→ Cloning provision repository..."
    git clone https://github.com/Abourass/provision.git "$INSTALL_DIR"
    cd "$INSTALL_DIR"
fi

# Make bootstrap executable
chmod +x bootstrap.sh

# Run bootstrap
echo ""
echo "→ Running bootstrap script..."
echo ""
./bootstrap.sh
