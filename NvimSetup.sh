#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to print messages
print_message() {
    echo "================================================="
    echo "$1"
    echo "================================================="
}

# Install Neovim
print_message "Installing Neovim"
if command -v nvim &>/dev/null; then
    echo "Neovim is already installed."

elif [ -f "/etc/arch-release" ]; then

    sudo pacman -S neovim

else
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    sudo rm -rf /opt/nvim
    sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
    export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
fi

if ! command -v unzip &>/dev/null; then
    print_message "Installing unzip"
    if [ -f /etc/debian_version ]; then
        sudo apt update
        sudo apt install -y unzip
    elif [ -f /etc/redhat-release ]; then
        sudo yum install -y unzip
    elif [ -f /etc/arch-release ]; then
        sudo pacman -S --noconfirm unzip
    elif [ "$(uname)" == "Darwin" ]; then
        brew install unzip
    else
        echo "Unsupported OS. Please install unzip manually."
        exit 1
    fi
fi

# Install vim-plug
print_message "Installing vim-plug"
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Clone the configuration repository from GitHub
print_message "Cloning configuration repository from GitHub"
CONFIG_REPO="https://github.com/SykesTheLord/NeoVimConfig.git"
CONFIG_DIR="$HOME/.config/nvim"

if [ -d "$CONFIG_DIR" ]; then
    echo "Backup existing Neovim configuration to $CONFIG_DIR.bak"
    mv "$CONFIG_DIR" "$CONFIG_DIR.bak"
fi

git clone "$CONFIG_REPO" "$CONFIG_DIR"

# Install plugins
print_message "Installing plugins"
zsh -c "nvim +PlugInstall +qall"

sleep 300

# Install Node.js version 18 and npm (for general tooling)
print_message "Installing Node.js version 18 and npm"
if command -v npm &>/dev/null; then
    echo "npm is already installed."
else
    if [ -f /etc/debian_version ]; then
        curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
        sudo apt install -y nodejs npm
    elif [ -f /etc/redhat-release ]; then
        curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -
        sudo yum install -y nodejs
    elif [ -f /etc/arch-release ]; then
        sudo pacman -S --noconfirm nodejs npm
    elif [ "$(uname)" == "Darwin" ]; then
        brew install node@18
        brew link --force node@18
    else
        echo "Unsupported OS. Please install Node.js version 18 and npm manually."
        exit 1
    fi
fi

# Ensure npm is in PATH
export PATH="$PATH:$(npm bin -g)"

# Verify npm installation
if ! command -v npm &>/dev/null; then
    echo "npm is not installed correctly. Please check the installation and try again."
    exit 1
fi

# Install tree-sitter CLI
print_message "Installing tree-sitter CLI"
sudo npm install -g tree-sitter-cli

# Verify tree-sitter CLI installation
if ! command -v tree-sitter &>/dev/null; then
    echo "tree-sitter CLI is not installed correctly. Please check the installation and try again."
    exit 1
fi

# sudo npm install -g @ansible/ansible-language-server
# sudo npm install -g azure-pipelines-language-server
# sudo npm i -g bash-language-server


print_message "Setup complete! You can now start Neovim with 'nvim'."
