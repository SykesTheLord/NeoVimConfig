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
else
    if [ -f /etc/debian_version ]; then
        sudo apt update
        sudo apt install -y neovim
    elif [ -f /etc/redhat-release ]; then
        sudo yum install -y epel-release
        sudo yum install -y neovim
    elif [ -f /etc/arch-release ]; then
        sudo pacman -S --noconfirm neovim
    elif [ "$(uname)" == "Darwin" ]; then
        brew install neovim
    else
        echo "Unsupported OS. Please install Neovim manually."
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
nvim +PlugInstall +qall

# Install Python dependencies for COC
print_message "Installing Python dependencies for COC"
if [ -f /etc/debian_version ]; then
    sudo apt install -y python3-neovim python3-pynvim
else
    pip3 install --user pynvim
fi

# Install Node.js version 18 and npm (required for COC)
print_message "Installing Node.js version 18 and npm"
if command -v npm &>/dev/null; then
    echo "npm is already installed."
else
    if [ -f /etc/debian_version ]; then
        curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
        sudo apt install -y nodejs
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

# Install tree-sitter CLI
print_message "Installing tree-sitter CLI"
npm install -g tree-sitter-cli

# Install COC extensions
print_message "Installing COC extensions"
nvim +'CocInstall -sync coc-snippets coc-tsserver coc-eslint coc-prettier coc-python coc-json coc-yaml coc-clangd coc-omnisharp coc-terraform coc-docker coc-sh' +qall

print_message "Setup complete! You can now start Neovim with 'nvim'."
