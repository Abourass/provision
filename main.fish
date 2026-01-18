#!/usr/bin/env fish

# Main provisioning orchestrator

# Get the directory where this script is located
set SCRIPT_DIR (dirname (status -f))

# Source helper functions
source $SCRIPT_DIR/lib/helpers.fish

echo ""
echo "======================================"
echo "  Optional Tools Selection"
echo "======================================"
echo ""
echo "Select optional tools to install:"
echo "(Use Space to select, Enter to confirm)"
echo ""

# Define optional tools
set optional_tools "Slack" "Discord" "DotNet SDK (Unity)"

# Use gum to select optional tools (multi-select)
set selected_tools (gum choose --no-limit $optional_tools)

# Set environment variables based on selections
if contains "Slack" $selected_tools
    set -gx INSTALL_SLACK "yes"
else
    set -gx INSTALL_SLACK "no"
end

if contains "Discord" $selected_tools
    set -gx INSTALL_DISCORD "yes"
else
    set -gx INSTALL_DISCORD "no"
end

if contains "DotNet SDK (Unity)" $selected_tools
    set -gx INSTALL_DOTNET "yes"
else
    set -gx INSTALL_DOTNET "no"
end

echo ""
echo "======================================"
echo "  Installing All Tools"
echo "======================================"
echo ""

if test (count $selected_tools) -gt 0
    echo "Optional tools selected:"
    for tool in $selected_tools
        echo "  • $tool"
    end
    echo ""
end

echo "Installing all required tools automatically..."
echo ""

# Define module execution order
set modules "dev-languages" "cli-tools" "software" "editors"

# Run each module
for module in $modules
    set module_path $SCRIPT_DIR/modules/$module.fish

    if test -f $module_path
        echo ""
        echo "Running module: $module"
        fish $module_path

        if test $status -eq 0
            echo "✓ Module $module completed successfully"
        else
            echo "✗ Module $module failed"
        end
    else
        echo "Warning: Module file not found: $module_path"
    end
end

echo ""
echo "======================================"
echo "  Provisioning Complete!"
echo "======================================"
echo ""
echo "All tools have been installed."
echo ""

# Suggest setting fish as default shell if not already
if test $SHELL != (which fish)
    echo "Tip: To set fish as your default shell, run:"
    echo "  chsh -s (which fish)"
    echo ""
end

echo "Tip: Add these to your ~/.config/fish/config.fish:"
echo "  eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
echo "  fnm env | source"
echo "  zoxide init fish | source"
echo ""
