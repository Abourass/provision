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

    # Add Microsoft GPG key
    if not test -f /etc/apt/keyrings/packages.microsoft.gpg
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
        sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
        rm packages.microsoft.gpg
    end

    # Add VS Code repository
    if not test -f /etc/apt/sources.list.d/vscode.list
        echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
        sudo apt update
    end

    apt_install code
end

success "VS Code installed!"
