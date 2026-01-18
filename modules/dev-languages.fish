#!/usr/bin/env fish

# Development Languages Module
# Installs: Node.js (via FNM), Bun, Go, Unity/DotNet SDK (optional)
# NOTE: FNM should be installed by bootstrap.sh

set SCRIPT_DIR (dirname (status -f))
source $SCRIPT_DIR/../lib/helpers.fish

module_header "Development Languages"

# Node.js via FNM
echo "Installing Node.js via FNM..."
if not is_installed fnm
    error "FNM not found! It should have been installed by bootstrap.sh."
    error "Please ensure bootstrap.sh completed successfully."
    exit 1
end

# Check if node is installed via FNM
if is_installed node
    echo "  ✓ Node.js already installed (version: "(node --version)")"
else
    echo "  → Finding latest Node.js LTS version..."

    # Get latest LTS version from FNM
    set latest_lts (fnm list-remote | grep -i 'lts' | tail -1 | awk '{print $1}')

    if test -z "$latest_lts"
        # Fallback to just installing latest
        echo "  → Installing latest Node.js..."
        fnm install --lts
    else
        echo "  → Installing Node.js $latest_lts..."
        fnm install $latest_lts
    end

    # Set as default
    fnm default (fnm list | head -1)

    # Source for current session
    fnm env | source

    echo "  ✓ Node.js "(node --version)" installed"
end

# Bun
echo ""
echo "Installing Bun..."
if is_installed bun
    echo "  ✓ Bun already installed (version: "(bun --version)")"
else
    echo "  → Installing Bun..."
    curl -fsSL https://bun.sh/install | bash

    # Source for current session
    if test -f ~/.bun/bin/bun
        set -gx PATH ~/.bun/bin $PATH
    end
end

# Go
echo ""
echo "Installing Go..."
if is_installed go
    echo "  ✓ Go already installed (version: "(go version)")"
else
    echo "  → Fetching latest Go version..."

    # Get the latest version filename from go.dev/dl
    set GO_ARCHIVE (curl -sL https://go.dev/dl/ | grep -oP 'go[0-9]+\.[0-9]+(\.[0-9]+)?\.linux-amd64\.tar\.gz' | head -1)

    if test -z "$GO_ARCHIVE"
        error "Failed to fetch latest Go version"
        exit 1
    end

    echo "  → Installing Go ($GO_ARCHIVE)..."
    curl -fsSL "https://go.dev/dl/$GO_ARCHIVE" -o /tmp/$GO_ARCHIVE

    # Remove previous installation and extract
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf /tmp/$GO_ARCHIVE
    rm /tmp/$GO_ARCHIVE

    # Add to PATH if not already there
    if not contains /usr/local/go/bin $PATH
        echo "  → Adding Go to PATH..."
        fish_add_path /usr/local/go/bin
    end

    echo "  ✓ Go "(go version | awk '{print $3}')" installed"
end

# Unity / .NET SDK (Optional - based on user selection)
echo ""
if test "$INSTALL_DOTNET" = "yes"
    echo "Installing .NET SDK..."
    if is_installed dotnet
        echo "  ✓ .NET SDK already installed"
    else
        echo "  → Installing .NET SDK..."

        # Add Microsoft package repository
        if not test -f /etc/apt/sources.list.d/microsoft-prod.list
            # Get Ubuntu version
            set ubuntu_version (lsb_release -rs)

            wget https://packages.microsoft.com/config/ubuntu/$ubuntu_version/packages-microsoft-prod.deb -O /tmp/packages-microsoft-prod.deb
            sudo dpkg -i /tmp/packages-microsoft-prod.deb
            rm /tmp/packages-microsoft-prod.deb

            sudo apt update
        end

        apt_install dotnet-sdk-8.0 dotnet
    end
else
    echo "  ⊗ Skipping Unity/DotNet SDK"
end

success "Development languages installed!"
