#!/usr/bin/env fish

# CLI Tools Module
# Installs various CLI utilities and shell enhancements

set SCRIPT_DIR (dirname (status -f))
source $SCRIPT_DIR/../lib/helpers.fish

module_header "CLI Tools"

# Oh My Posh (shell prompt theme engine)
echo "Installing Oh My Posh..."
if is_installed oh-my-posh
    echo "  ✓ Oh My Posh already installed"
else
    echo "  → Installing Oh My Posh..."
    curl -s https://ohmyposh.dev/install.sh | bash -s
end

echo ""
echo "Installing APT-based CLI tools..."

# Fun/visual tools
apt_install cbonsai
apt_install cowsay
apt_install fortune
apt_install jp2a
apt_install linuxlogo
apt_install toilet
apt_install hyfetch

# Utility tools
apt_install bat
apt_install pv
apt_install sqlite3
apt_install jq

# Create bat symlink if needed (some distros install as batcat)
if not is_installed bat; and is_installed batcat
    echo "  → Creating bat symlink..."
    mkdir -p ~/.local/bin
    ln -sf /usr/bin/batcat ~/.local/bin/bat
    fish_add_path ~/.local/bin
end

echo ""
echo "Installing Homebrew-based CLI tools..."

# Modern CLI replacements
brew_install glow
brew_install fzf
brew_install timg
brew_install watchman
brew_install lsd
brew_install fx
brew_install navi
brew_install rig

# Additional useful tools
brew_install ripgrep rg
brew_install eza
brew_install zoxide
brew_install fd

# Setup fzf key bindings
if is_installed fzf
    echo ""
    echo "  → Setting up fzf..."
    if not test -f ~/.config/fish/functions/fzf_key_bindings.fish
        mkdir -p ~/.config/fish/functions
        # Generate fzf key bindings for fish
        fzf --fish > ~/.config/fish/functions/fzf_key_bindings.fish 2>/dev/null || true
    end
end

# Setup zoxide for fish
if is_installed zoxide
    echo ""
    echo "  → Zoxide is installed. Add 'zoxide init fish | source' to your config.fish to enable it."
end

success "CLI tools installed!"
