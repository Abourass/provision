#!/usr/bin/env fish

# Software Module
# Installs: Brave Browser, Slack (optional), Discord (optional)

set SCRIPT_DIR (dirname (status -f))
source $SCRIPT_DIR/../lib/helpers.fish

module_header "Software & Applications"

# Brave Browser
echo "Installing Brave Browser..."
if is_installed brave-browser
    echo "  ✓ Brave already installed"
else
    echo "  → Installing Brave Browser..."

    # Add Brave repository
    if not test -f /etc/apt/sources.list.d/brave-browser-release.list
        sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
        echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
        sudo apt update
    end

    apt_install brave-browser
end

# Slack (Optional - based on user selection)
echo ""
if test "$INSTALL_SLACK" = "yes"
    echo "Installing Slack..."
    if is_installed slack
        echo "  ✓ Slack already installed"
    else
        echo "  → Installing Slack via snap..."
        snap_install slack --classic
    end
else
    echo "  ⊗ Skipping Slack"
end

# Discord (Optional - based on user selection)
echo ""
if test "$INSTALL_DISCORD" = "yes"
    echo "Installing Discord..."
    if is_installed discord
        echo "  ✓ Discord already installed"
    else
        echo "  → Installing Discord via snap..."
        snap_install discord
    end
else
    echo "  ⊗ Skipping Discord"
end

success "Software installed!"
