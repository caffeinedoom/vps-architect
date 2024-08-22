#!/bin/bash

# Custom VPS Setup Script
# This script sets up a VPS with essential tools and configurations

# Error handling
set -e

# Function to log messages
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Update and upgrade system packages
log "Updating and upgrading system packages"
apt update && apt upgrade -y 

# Install Zsh (Z shell)
log "Installing Zsh"
apt install zsh -y

# Install Python3 and pip
log "Installing Python3 and pip"
apt install -y python3-pip

# Install Python development tools
log "Installing Python development tools"
apt install -y build-essential libssl-dev libffi-dev python3-dev

# Install Python virtual environment
log "Installing Python virtual environment"
apt install -y python3-venv

# Install Tmux (terminal multiplexer)
log "Installing Tmux"
apt install tmux -y

# Install networking tools
log "Installing networking tools"
apt install net-tools -y

# Install various build tools and utilities
log "Installing build tools and utilities"
apt install make autoconf automake libtool pkg-config gcc unzip -y

# Install Oh My Zsh (Zsh configuration framework)
log "Installing Oh My Zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Clone .tmux configuration
log "Cloning .tmux configuration"
git clone https://github.com/gpakosz/.tmux.git

# Download Go programming language
log "Downloading Go"
wget https://go.dev/dl/go1.22.5.linux-amd64.tar.gz

# Install Go
log "Installing Go"
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.22.5.linux-amd64.tar.gz

# Add Go to PATH
log "Adding Go to PATH"
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.zshrc
echo 'export PATH=$PATH:/usr/local/go/bin:~/go/bin' >> ~/.zshrc

# Clean up Go installation file
log "Cleaning up Go installation file"
rm -rf go1.22.5.linux-amd64.tar.gz

# Add ve() function to .zshrc
log "Adding ve() function to .zshrc"
cat << 'EOF' >> ~/.zshrc

# Function to create and activate Python virtual environments
ve() {
    local py=${1:-python3}
    local venv="${2:-./.venv}"
    local bin="${venv}/bin/activate"

    if [ -z "${VIRTUAL_ENV}" ]; then
        if [ ! -d "${venv}" ]; then
            echo "Creating and activating virtual environment ${venv}"
            ${py} -m venv ${venv} --without-pip
            source ${bin}
            echo "Upgrading pip"
            curl -sS https://bootstrap.pypa.io/get-pip.py | ${py}
        else
            echo "Virtual environment ${venv} already exists, activating..."
            source ${bin}
        fi
    else
        echo "Already in a virtual environment!"
    fi

    # Ensure pip points to the virtual environment's pip
    hash -r
    which pip
    which python
}
EOF

