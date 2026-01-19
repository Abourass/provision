# Provision

A streamlined provisioning tool for setting up new Debian-based systems (Ubuntu, Linux Mint, etc.) with all your essential development tools.

## Features

- **Fully Automated**: One command installs everything with minimal interaction
- **Idempotent**: Safe to run multiple times - won't reinstall existing tools
- **Smart Selection**: Only prompts for truly optional tools (Slack, Discord, Unity/DotNet)
- **Modern Stack**: Fish shell, Homebrew, FNM, and cutting-edge CLI tools

## Quick Start

### One-Line Installation (Recommended)

Run this single command on a fresh Debian-based system:

```bash
curl -fsSL https://raw.githubusercontent.com/Abourass/provision/main/setup.sh | bash
```

This command will:
1. Install git if not already present
2. Clone the repository to `~/provision`
3. Run the bootstrap script to provision your entire system

> **Note**: Safe to run multiple times! If `~/provision` already exists, it will pull the latest changes and re-run.

### Alternative: Manual Installation

If you prefer to review the code first or already have git installed:

```bash
# Clone this repo
git clone https://github.com/Abourass/provision.git ~/provision
cd ~/provision

# Run the bootstrap script
./bootstrap.sh
```

## What Gets Installed

### Phase 1: Bootstrap (Automatic)
The `bootstrap.sh` script auto-installs core dependencies:
- **curl, git, build-essential**: Essential build tools
- **Fish Shell**: Modern shell (via PPA release-4)
- **Homebrew**: Package manager for Linux
- **Gum**: Interactive CLI tool
- **FNM**: Fast Node Manager
- **PNPM**: Fast, efficient package manager

### Phase 2: Optional Tools Selection
You'll see a Gum selector with only these optional tools:
- **Slack**: Team communication platform
- **Discord**: Chat and voice platform
- **DotNet SDK**: For Unity game development

Everything else installs automatically.

### Phase 3: Automatic Installation
All required tools install automatically:

**Development Languages:**
- Node.js (latest LTS via FNM)
- Bun (JavaScript runtime)
- Go (1.22.0)

**CLI Tools:**
- **Oh My Posh**: Shell prompt theming
- **APT tools**: bat, cbonsai, cowsai, fortune, jp2a, linuxlogo, toilet, hyfetch, pv, sqlite3, jq
- **Homebrew tools**: glow, fzf, timg, watchman, lsd, fx, navi, rig, ripgrep, eza, zoxide, fd

**Desktop Software:**
- Brave Browser (privacy-focused browser)
- VS Code (code editor)

**Shell Configuration:**
- Claude Code (CLI tool for Claude AI)
- Oh My Posh configuration (FiraCode font, Claude feature, custom theme)
- Familiar Says (greeting tool with fortune integration)
- Complete Fish shell configuration with all integrations

## Execution Flow

```
curl setup.sh | bash (or ./setup.sh)
  ↓
Check & Install: git (if needed)
  ↓
Clone/Update: provision repo
  ↓
./bootstrap.sh
  ↓
Install: curl, build-essential
  ↓
Install: Fish shell (PPA)
  ↓
Install: Homebrew
  ↓
Verify: Homebrew in PATH (or abort with instructions)
  ↓
Install: Gum, FNM, PNPM
  ↓
Launch: main.fish
  ↓
Prompt: "Select optional tools" (Slack, Discord, DotNet)
  ↓
Auto-install all modules:
  - dev-languages
  - cli-tools
  - software
  - editors
  - shell-config (prompts for code location)
  ↓
Done!
```

## Project Structure

```
provision/
├── setup.sh              # Quick setup wrapper (installs git + runs bootstrap)
├── bootstrap.sh          # Core tools installer (bash)
├── main.fish             # Orchestrator with optional tool selection
├── modules/              # Auto-run installation modules
│   ├── dev-languages.fish   # Node, Bun, Go, DotNet
│   ├── cli-tools.fish       # Oh My Posh + modern CLI tools
│   ├── software.fish        # Brave, Slack, Discord
│   ├── editors.fish         # VS Code
│   └── shell-config.fish    # Claude Code, oh-my-posh config, familiar-says, fish config
├── lib/
│   └── helpers.fish      # Shared utility functions
└── config/               # Future: config files
```

## Already Installed Tools

If any tool is already installed, the script will detect it and skip reinstallation, showing:
```
✓ tool-name already installed
```

This makes the script safe to run multiple times.

## PATH Verification

The bootstrap script verifies Homebrew is accessible after installation. If not found in PATH, it will abort with clear instructions:

```
ERROR: Homebrew was installed but is not in PATH.

Please add Homebrew to your PATH by running:
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

Then add this line to your shell configuration file:
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc

After updating your PATH, re-run this script.
```

## Post-Installation Setup

### Set Fish as Default Shell

```bash
chsh -s $(which fish)
```

### Fish Shell Configuration (Automated)

The `shell-config` module automatically configures your Fish shell with:
- Custom oh-my-posh theme with Claude integration
- Familiar-says greeting with fortune integration
- Homebrew completions
- Go, PNPM, and Bun environment setup
- FNM and Zoxide initialization

Your `~/.config/fish/config.fish` is automatically created with all necessary configurations.

To activate the configuration after installation:
```bash
source ~/.config/fish/config.fish
# or restart your terminal
```

## Helper Functions

Available in `lib/helpers.fish` for custom modules:

- `is_installed <command>`: Check if a command exists
- `apt_install <package> [check_cmd]`: Install apt package if missing
- `brew_install <package> [check_cmd]`: Install Homebrew package if missing
- `cargo_install <package> [check_cmd]`: Install cargo package if missing
- `npm_install_global <package> [check_cmd]`: Install npm package globally
- `snap_install <package> [flags]`: Install snap package if missing
- `add_ppa <ppa>`: Add PPA repository if not already added
- `module_header <title>`: Print formatted module header
- `success <message>`: Print success message
- `error <message>`: Print error message
- `confirm <prompt>`: Ask for confirmation via Gum

## Creating Custom Modules

1. Create a new file in `modules/` (e.g., `modules/my-tools.fish`)
2. Use the helper functions from `lib/helpers.fish`
3. Make it executable: `chmod +x modules/my-tools.fish`
4. Add it to the modules list in `main.fish`

### Example Module

```fish
#!/usr/bin/env fish

# My Custom Tools Module

set SCRIPT_DIR (dirname (status -f))
source $SCRIPT_DIR/../lib/helpers.fish

module_header "My Custom Tools"

# Install from apt
echo "Installing vim..."
apt_install vim

# Install from brew
echo "Installing htop..."
brew_install htop

success "Custom tools installed!"
```

## Manual Module Execution

You can run individual modules for testing:

```bash
fish modules/cli-tools.fish
```

Note: Some modules (like `dev-languages`) require tools from bootstrap to be installed first.

## Requirements

- Debian-based Linux distribution (Ubuntu, Linux Mint, Pop!_OS, etc.)
- `sudo` access
- Internet connection

## Troubleshooting

### Homebrew Not in PATH
If bootstrap fails with PATH error, manually add Homebrew to PATH and re-run:
```bash
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
./bootstrap.sh
```

### FNM Not Found in dev-languages Module
Ensure bootstrap.sh completed successfully. FNM should be installed during bootstrap phase.

### Module Fails
Check the module output for specific error messages. Most errors are due to network issues or missing sudo permissions.

## Customization

To change which tools are required vs optional:
1. Edit `main.fish` to add/remove items from the `optional_tools` list
2. Update the corresponding module to check the environment variable
3. Set environment variables like `INSTALL_TOOLNAME` to "yes" or "no"

## License

MIT
