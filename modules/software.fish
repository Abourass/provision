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
    curl -fsS https://dl.brave.com/install.sh | sh
end

# Slack (Optional - based on user selection)
echo ""
if test "$INSTALL_SLACK" = "yes"
    echo "Installing Slack..."
    if is_installed slack
        echo "  ✓ Slack already installed"
    else
        echo "  → Installing Slack via .deb package..."
        install_deb_from_url "https://slack.com/downloads/instructions/linux?ddl=1&build=deb"
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
        echo "  → Installing Discord via .deb package..."
        install_deb_from_url "https://discord.com/api/download?platform=linux&format=deb"
    end
else
    echo "  ⊗ Skipping Discord"
end

success "Software installed!"
