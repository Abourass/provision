#!/usr/bin/env fish

# Editors Module
# Installs: VS Code

set SCRIPT_DIR (dirname (status -f))
source $SCRIPT_DIR/../lib/helpers.fish

module_header "Text Editors & IDEs"

# VS Code
echo "Installing VS Code..."
if is_installed code
    echo "  ✓ VS Code already installed"
else
    echo "  → Installing VS Code..."

    # Install prerequisites
    sudo apt-get install -y wget gpg

    # Add Microsoft GPG key
    if not test -f /usr/share/keyrings/microsoft.gpg
        echo "  → Adding Microsoft GPG key..."
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
        sudo install -D -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft.gpg
        rm -f microsoft.gpg
    end

    # Create VS Code sources file
    if not test -f /etc/apt/sources.list.d/vscode.sources
        echo "  → Adding VS Code repository..."
        echo "Types: deb
URIs: https://packages.microsoft.com/repos/code
Suites: stable
Components: main
Architectures: amd64,arm64,armhf
Signed-By: /usr/share/keyrings/microsoft.gpg" | sudo tee /etc/apt/sources.list.d/vscode.sources > /dev/null
    end

    # Install apt-transport-https and update
    sudo apt install -y apt-transport-https
    sudo apt update

    # Install VS Code
    apt_install code
end

success "VS Code installed!"
