#!/usr/bin/env fish

# Shell Configuration Module
# Installs claude-code, configures oh-my-posh, sets up preferred code location,
# installs familiar-says, and configures fish shell

set SCRIPT_DIR (dirname (status -f))
source $SCRIPT_DIR/../lib/helpers.fish

module_header "Shell Configuration"

# Install claude-code
echo "Installing claude-code..."
if is_installed claude
    echo "  ✓ claude-code already installed"
else
    echo "  → Installing claude-code..."
    curl -fsSL https://claude.ai/install.sh | bash

    # Add to PATH for current session if needed
    if test -f ~/.local/bin/claude
        fish_add_path ~/.local/bin
    end
end

# Configure oh-my-posh
echo ""
echo "Configuring oh-my-posh..."

# Install firacode font
echo "  → Installing FiraCode font..."
if is_installed oh-my-posh
    # Check if font is already installed by looking for font files
    if test -d ~/.local/share/fonts; and find ~/.local/share/fonts -name "*FiraCode*" -o -name "*firacode*" | grep -q .
        echo "  ✓ FiraCode font already installed"
    else
        echo "  → Installing FiraCode font via oh-my-posh..."
        oh-my-posh font install firacode --user
    end
else
    error "oh-my-posh not found! It should have been installed by cli-tools module."
    exit 1
end

# Enable upgrades (idempotent - safe to run multiple times)
if not test -f ~/.cache/oh-my-posh/upgrade_check_enabled
    echo "  → Enabling oh-my-posh upgrades..."
    oh-my-posh enable upgrade
    mkdir -p ~/.cache/oh-my-posh
    touch ~/.cache/oh-my-posh/upgrade_check_enabled
else
    echo "  ✓ oh-my-posh upgrades already enabled"
end

# Enable claude feature (idempotent - safe to run multiple times)
if not test -f ~/.cache/oh-my-posh/claude_feature_enabled
    echo "  → Enabling oh-my-posh claude feature..."
    oh-my-posh claude
    mkdir -p ~/.cache/oh-my-posh
    touch ~/.cache/oh-my-posh/claude_feature_enabled
else
    echo "  ✓ oh-my-posh claude feature already enabled"
end

# Create oh-my-posh config directory
ensure_dir ~/.config/ohmyposh

# Install custom theme only if it doesn't exist
if test -f ~/.config/ohmyposh/theme.json
    echo "  ✓ oh-my-posh theme already exists (skipping to preserve customizations)"
else
    echo "  → Installing custom oh-my-posh theme..."
    cat > ~/.config/ohmyposh/theme.json << 'THEME_EOF'
{
  "$schema": "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json",
  "palette": {
    "white": "#FFFFFF",
    "tan": "#CC3802",
    "teal": "#047E84",
    "plum": "#9A348E",
    "blush": "#DA627D",
    "salmon": "#FCA17D",
    "sky": "#86BBD8",
    "teal_blue": "#33658A",
    "claude_orange": "#FF6B35"
  },
  "blocks": [
    {
      "alignment": "right",
      "segments": [
        {
          "type": "text",
          "style": "diamond",
          "leading_diamond": "\ue0b6",
          "foreground": "p:white",
          "background": "p:tan",
          "template": "{{ if .Env.PNPPSHOST }} \uf8c5 {{ .Env.PNPPSHOST }} {{ end }}"
        },
        {
          "type": "text",
          "style": "powerline",
          "foreground": "p:white",
          "background": "p:teal",
          "powerline_symbol": "\ue0b0",
          "template": "{{ if .Env.PNPPSSITE }} \uf2dd {{ .Env.PNPPSSITE }}{{ end }}"
        },
        {
          "type": "text",
          "style": "diamond",
          "trailing_diamond": "\ue0b4",
          "foreground": "p:white",
          "background": "p:teal",
          "template": "{{ if .Env.PNPPSSITE }}\u00A0{{ end }}"
        },
        {
          "background": "#e91e63",
          "foreground": "p:white",
          "leading_diamond": " \ue0b6",
          "properties": {
            "always_enabled": false
          },
          "style": "diamond",
          "template": " \uf00d {{ .Code }} ",
          "trailing_diamond": "\ue0b0",
          "type": "status"
        },
        {
          "background": "#8800dd",
          "foreground": "p:white",
          "powerline_symbol": "\ue0b0",
          "properties": {
            "threshold": 500,
            "style": "austin"
          },
          "style": "powerline",
          "template": " \uf252 {{ .FormattedMs }} ",
          "type": "executiontime"
        },
        {
          "background": "p:sky",
          "foreground": "p:white",
          "powerline_symbol": "\ue0b0",
          "properties": {
            "fetch_version": true,
            "fetch_package_manager": true,
            "display_mode": "always"
          },
          "style": "powerline",
          "template": " {{ if .PackageManagerIcon }}{{ .PackageManagerIcon }}{{ end }} {{ .Full }} ",
          "type": "node"
        },
        {
          "background": "p:teal_blue",
          "foreground": "p:white",
          "powerline_symbol": "\ue0b0",
          "properties": {
            "time_format": "15:04"
          },
          "style": "powerline",
          "template": " \u2665 {{ .CurrentDate | date .Format }} ",
          "trailing_diamond": "\ue0b4",
          "type": "time"
        }
      ],
      "type": "rprompt"
    },
    {
      "alignment": "left",
      "segments": [
        {
          "background": "p:plum",
          "foreground": "p:white",
          "leading_diamond": "\ue0b6",
          "style": "diamond",
          "template": " {{ .UserName }} ",
          "type": "session"
        },
        {
          "background": "p:blush",
          "foreground": "p:white",
          "powerline_symbol": "\ue0b0",
          "properties": {
            "style": "folder"
          },
          "style": "powerline",
          "template": " {{ .Path }} ",
          "type": "path"
        },
        {
          "background": "p:salmon",
          "foreground": "p:white",
          "powerline_symbol": "\ue0b0",
          "properties": {
            "branch_icon": "",
            "fetch_status": true,
            "fetch_stash_count": true,
            "fetch_upstream_icon": true
          },
          "style": "powerline",
          "template": " \u279c {{ .UpstreamIcon }}{{ .HEAD }}{{ if .Working.Changed }} \uf044 {{ .Working.String }}{{ end }}{{ if .Staging.Changed }} \uf046 {{ .Staging.String }}{{ end }}{{ if gt .StashCount 0 }} \ueb4b {{ .StashCount }}{{ end }} ",
          "type": "git"
        },
        {
          "type": "text",
          "style": "powerline",
          "powerline_symbol": "\ue0b0",
          "foreground": "p:white",
          "background": "#FFA500",
          "template": "{{ if .Env.UPDATES_AVAILABLE }} \uf466 {{ .Env.UPDATES_AVAILABLE }} {{ end }}"
        },
        {
          "type": "claude",
          "style": "powerline",
          "powerline_symbol": "\ue0b0",
          "foreground": "p:white",
          "background": "p:claude_orange",
          "template": " \udb82\udfc9 {{ .Model.DisplayName }} {{ .TokenUsagePercent.Gauge }} {{ .FormattedCost }} "
        },
        {
          "background": "#00ADD8",
          "foreground": "p:white",
          "powerline_symbol": "\ue0b0",
          "style": "powerline",
          "template": " \ue627 {{ .Full }} ",
          "type": "go"
        },
        {
          "background": "#512BD4",
          "foreground": "p:white",
          "powerline_symbol": "\ue0b0",
          "style": "diamond",
          "template": " \ue77f {{ .Full }} ",
          "trailing_diamond": "\ue0b0",
          "type": "dotnet"
        }
      ],
      "type": "prompt"
    }
  ],
  "final_space": true,
  "version": 4
}
THEME_EOF

    echo "  ✓ oh-my-posh theme configured"
end

# Ask user for preferred code location (only if not already configured)
set PREF_CODE_MARKER "$HOME/.config/provision/preferred_code_location"

if test -f "$PREF_CODE_MARKER"
    set PREFERRED_REPO_LOCATION (cat "$PREF_CODE_MARKER")
    echo ""
    echo "  ✓ Using saved code location: $PREFERRED_REPO_LOCATION"
else
    echo ""
    echo "Setting up preferred code location..."
    echo ""
    echo "Where do you prefer to store your code projects?"
    echo "(Enter a folder name under your home directory, e.g., 'Code', 'Projects', 'src')"
    echo ""

    # Use gum input to get the folder name
    set code_folder (gum input --placeholder "Code")

    # Default to "Code" if empty
    if test -z "$code_folder"
        set code_folder "Code"
    end

    set PREFERRED_REPO_LOCATION "$HOME/$code_folder"

    # Save the preference
    ensure_dir (dirname "$PREF_CODE_MARKER")
    echo "$PREFERRED_REPO_LOCATION" > "$PREF_CODE_MARKER"
    echo "  ✓ Saved preference to $PREF_CODE_MARKER"
end

# Create the directory if it doesn't exist
if not test -d "$PREFERRED_REPO_LOCATION"
    echo "  → Creating directory: $PREFERRED_REPO_LOCATION"
    mkdir -p "$PREFERRED_REPO_LOCATION"
else
    echo "  ✓ Directory already exists: $PREFERRED_REPO_LOCATION"
end

# Clone and build familiar-says
echo ""
echo "Installing familiar-says..."

set FAMILIAR_SAYS_PATH "$PREFERRED_REPO_LOCATION/familiar-says"

if test -d "$FAMILIAR_SAYS_PATH"
    echo "  ✓ familiar-says already cloned"
else
    echo "  → Cloning familiar-says repository..."
    git clone https://github.com/MagikIO/familiar-says.git "$FAMILIAR_SAYS_PATH"
end

# Build familiar-says
if test -f "$FAMILIAR_SAYS_PATH/familiar-says"
    echo "  ✓ familiar-says already built"
else
    echo "  → Building familiar-says..."
    cd "$FAMILIAR_SAYS_PATH"
    go build -o familiar-says .
    cd -
end

# Configure fish shell
echo ""
echo "Configuring fish shell..."

set FISH_CONFIG "$HOME/.config/fish/config.fish"

# Create fish config directory if it doesn't exist
ensure_dir (dirname "$FISH_CONFIG")

# Create config file if it doesn't exist
if not test -f "$FISH_CONFIG"
    echo "  → Creating new fish config file"
    touch "$FISH_CONFIG"
end

# Create backup before making any changes
backup_file "$FISH_CONFIG"

# Add fish greeting section
append_config_section "$FISH_CONFIG" \
    "# PROVISION: fish_greeting" \
    "function fish_greeting" \
    "# PROVISION: fish_greeting" \
    "function fish_greeting" \
    "    fortune -s | $FAMILIAR_SAYS_PATH/familiar-says --think --character suse --theme cyber" \
    "end"

# Add Oh My Posh theme section
append_config_section "$FISH_CONFIG" \
    "# PROVISION: oh-my-posh" \
    "oh-my-posh init fish" \
    "# PROVISION: oh-my-posh" \
    "if status is-interactive" \
    "    oh-my-posh init fish --config ~/.config/ohmyposh/theme.json | source" \
    "end"

# Add Homebrew section
append_config_section "$FISH_CONFIG" \
    "# PROVISION: homebrew" \
    "brew shellenv" \
    "# PROVISION: homebrew" \
    "eval \"\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)\"" \
    "" \
    "if test -d (brew --prefix)\"/share/fish/completions\"" \
    "    set -p fish_complete_path (brew --prefix)/share/fish/completions" \
    "end" \
    "" \
    "if test -d (brew --prefix)\"/share/fish/vendor_completions.d\"" \
    "    set -p fish_complete_path (brew --prefix)/share/fish/vendor_completions.d" \
    "end"

# Add Go support section
append_config_section "$FISH_CONFIG" \
    "# PROVISION: go" \
    "GOPATH|/usr/local/go/bin" \
    "# PROVISION: go" \
    "fish_add_path /usr/local/go/bin" \
    "set -gx GOPATH \$HOME/go" \
    "fish_add_path \$GOPATH/bin"

# Add pnpm section
append_config_section "$FISH_CONFIG" \
    "# PROVISION: pnpm" \
    "PNPM_HOME" \
    "# PROVISION: pnpm" \
    "set -gx PNPM_HOME \"$HOME/.local/share/pnpm\"" \
    "if not string match -q -- \$PNPM_HOME \$PATH" \
    "    set -gx PATH \"\$PNPM_HOME\" \$PATH" \
    "end"

# Add Bun support section
append_config_section "$FISH_CONFIG" \
    "# PROVISION: bun" \
    "BUN_INSTALL" \
    "# PROVISION: bun" \
    "set --export BUN_INSTALL \"\$HOME/.bun\"" \
    "set --export PATH \$BUN_INSTALL/bin \$PATH"

# Add FNM section
append_config_section "$FISH_CONFIG" \
    "# PROVISION: fnm" \
    "fnm env" \
    "# PROVISION: fnm" \
    "fnm env | source"

# Add Zoxide section
append_config_section "$FISH_CONFIG" \
    "# PROVISION: zoxide" \
    "zoxide init" \
    "# PROVISION: zoxide" \
    "if command -v zoxide &> /dev/null" \
    "    zoxide init fish | source" \
    "end"

echo "  ✓ Fish config updated at $FISH_CONFIG"

success "Shell configuration complete!"
echo ""
echo "IMPORTANT: To activate all changes, either:"
echo "  1. Restart your terminal, or"
echo "  2. Run: source ~/.config/fish/config.fish"
echo ""
