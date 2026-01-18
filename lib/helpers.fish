#!/usr/bin/env fish

# Helper functions for provisioning modules

# Check if a command/binary exists
function is_installed
    command -v $argv[1] &> /dev/null
end

# Install apt package if not already installed
function apt_install
    set package $argv[1]
    set check_cmd $argv[2]

    # If no check command provided, use package name
    if test -z "$check_cmd"
        set check_cmd $package
    end

    if is_installed $check_cmd
        echo "  ✓ $package already installed"
        return 0
    else
        echo "  → Installing $package..."
        sudo apt install -y $package
        return $status
    end
end

# Install multiple apt packages
function apt_install_multiple
    for package in $argv
        apt_install $package
    end
end

# Add a PPA if not already added
function add_ppa
    set ppa $argv[1]

    if test -f /etc/apt/sources.list.d/(string replace '/' '-' (string replace 'ppa:' '' $ppa)).list
        echo "  ✓ PPA $ppa already added"
    else
        echo "  → Adding PPA $ppa..."
        sudo add-apt-repository -y $ppa
        sudo apt update
    end
end

# Install snap package if not already installed
function snap_install
    set package $argv[1]
    set flags $argv[2..]

    if snap list $package &> /dev/null
        echo "  ✓ $package (snap) already installed"
        return 0
    else
        echo "  → Installing $package via snap..."
        sudo snap install $package $flags
        return $status
    end
end

# Install Homebrew package if not already installed
function brew_install
    set package $argv[1]
    set check_cmd $argv[2]

    # If no check command provided, use package name
    if test -z "$check_cmd"
        set check_cmd $package
    end

    if is_installed $check_cmd
        echo "  ✓ $package (brew) already installed"
        return 0
    else
        echo "  → Installing $package via brew..."
        brew install $package
        return $status
    end
end

# Install cargo package if not already installed
function cargo_install
    set package $argv[1]
    set check_cmd $argv[2]

    # If no check command provided, use package name
    if test -z "$check_cmd"
        set check_cmd $package
    end

    if is_installed $check_cmd
        echo "  ✓ $package (cargo) already installed"
        return 0
    else
        echo "  → Installing $package via cargo..."
        cargo install $package
        return $status
    end
end

# Install npm package globally if not already installed
function npm_install_global
    set package $argv[1]
    set check_cmd $argv[2]

    # If no check command provided, use package name
    if test -z "$check_cmd"
        set check_cmd $package
    end

    if is_installed $check_cmd
        echo "  ✓ $package (npm) already installed"
        return 0
    else
        echo "  → Installing $package via npm..."
        sudo npm install -g $package
        return $status
    end
end

# Download and install a .deb file from URL
function install_deb_from_url
    set url $argv[1]
    set temp_file /tmp/(basename $url)

    echo "  → Downloading from $url..."
    curl -fsSL -o $temp_file $url

    echo "  → Installing .deb package..."
    sudo apt install -y $temp_file

    rm -f $temp_file
end

# Create a directory if it doesn't exist
function ensure_dir
    if not test -d $argv[1]
        mkdir -p $argv[1]
    end
end

# Print a module header
function module_header
    echo ""
    echo "======================================"
    echo "  $argv[1]"
    echo "======================================"
    echo ""
end

# Print a success message
function success
    echo ""
    echo "✓ $argv[1]"
    echo ""
end

# Print an error message
function error
    echo ""
    echo "✗ Error: $argv[1]" >&2
    echo ""
end

# Ask for confirmation (returns 0 for yes, 1 for no)
function confirm
    set prompt $argv[1]
    gum confirm "$prompt"
end
