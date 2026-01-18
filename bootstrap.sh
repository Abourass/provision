#!/usr/bin/env bash

set -e

echo "======================================"
echo "  Provision - System Setup Bootstrap"
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

# Function to install apt package if not already installed
install_if_missing() {
    local package=$1
    local check_cmd=${2:-$1}

    if command_exists "$check_cmd"; then
        echo "✓ $package already installed"
    else
        echo "Installing $package..."
        sudo apt install -y "$package"
    fi
}

echo "==> Installing core tools..."
echo ""

# Update apt cache
echo "Updating apt cache..."
sudo apt update

# Install core essentials
install_if_missing "curl" "curl"
install_if_missing "git" "git"
install_if_missing "build-essential" "gcc"

# Install fish shell (using release-4 PPA)
if command_exists fish; then
    echo "✓ fish already installed"
else
    echo "Installing fish shell..."
    sudo add-apt-repository -y ppa:fish-shell/release-4
    sudo apt update
    sudo apt install -y fish
fi

# Install Homebrew
if command_exists brew; then
    echo "✓ Homebrew already installed"
else
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add brew to PATH for current session
    if [ -d "/home/linuxbrew/.linuxbrew" ]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
fi

# Verify brew is in PATH
if ! command_exists brew; then
    echo ""
    echo "ERROR: Homebrew was installed but is not in PATH."
    echo ""
    echo "Please add Homebrew to your PATH by running:"
    echo "  eval \"\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)\""
    echo ""
    echo "Then add this line to your shell configuration file:"
    echo "  echo 'eval \"\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)\"' >> ~/.bashrc"
    echo ""
    echo "After updating your PATH, re-run this script."
    exit 1
fi

# Install gum via Homebrew
if command_exists gum; then
    echo "✓ gum already installed"
else
    echo "Installing gum via Homebrew..."
    brew install gum
fi

# Install FNM (Fast Node Manager)
if command_exists fnm; then
    echo "✓ FNM already installed"
else
    echo "Installing FNM..."
    curl -fsSL https://fnm.vercel.app/install | bash

    # Source FNM for current session
    export PATH="$HOME/.local/share/fnm:$PATH"
    if [ -f "$HOME/.local/share/fnm/fnm" ]; then
        eval "$("$HOME/.local/share/fnm/fnm" env --shell bash)"
    fi
fi

# Install PNPM
if command_exists pnpm; then
    echo "✓ PNPM already installed"
else
    echo "Installing PNPM..."
    curl -fsSL https://get.pnpm.io/install.sh | sh -

    # Source PNPM for current session
    export PNPM_HOME="$HOME/.local/share/pnpm"
    export PATH="$PNPM_HOME:$PATH"
fi

echo ""
echo "==> Core tools installed successfully!"
echo "    ✓ Fish, Homebrew, Gum, FNM, PNPM"
echo ""

# Launch main provisioning script in fish
if [ -f "$(dirname "$0")/main.fish" ]; then
    echo "==> Launching provisioning script..."
    echo ""
    fish "$(dirname "$0")/main.fish"
else
    echo "Note: main.fish not found. Core installation complete."
    echo "You can now run fish and execute the provisioning modules."
fi
