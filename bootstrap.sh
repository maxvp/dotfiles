#!/bin/bash
# bootstrap.sh
# Single-command setup for Mac and Linux (Arch/Debian)

set -e # Exit immediately if a command exits with a non-zero status

# --- CONFIGURATION ---
DOTFILES_DIR="$HOME/dotfiles"
ANTIDOTE_DIR="$HOME/.antidote"

# --- COLORS ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}Starting Dotfiles Bootstrap...${NC}"

# --- 1. CLEANUP (REMOVE OMZ) ---
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${RED}Found Oh My Zsh. Removing...${NC}"
    rm -rf "$HOME/.oh-my-zsh"
    # Remove existing .zshrc if it's not a symlink (to avoid conflict with Stow)
    if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
        mv "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%s)"
        echo "Backed up existing .zshrc"
    fi
fi

# --- 2. OS DETECTION & INSTALLATION ---
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "${GREEN}Detected MacOS.${NC}"
    
    # Check for Homebrew
    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Brew to path for this session
        if [[ -f "/opt/homebrew/bin/brew" ]]; then eval "$(/opt/homebrew/bin/brew shellenv)"; fi
        if [[ -f "/usr/local/bin/brew" ]]; then eval "$(/usr/local/bin/brew shellenv)"; fi
    fi

    echo "Installing Packages via Brew..."
    brew install stow starship zsh antidote zoxide

elif [ -f "/etc/arch-release" ]; then
    echo -e "${GREEN}Detected Arch Linux.${NC}"
    echo "Installing Packages via Pacman..."
    sudo pacman -Syu --noconfirm zsh starship stow zoxide git base-devel

    # For Arch, we'll install Antidote manually to ensure consistency
    # (unless you have 'yay' set up, but this script assumes fresh install)
    if [ ! -d "$ANTIDOTE_DIR" ]; then
        git clone --depth=1 https://github.com/mattmc3/antidote.git "$ANTIDOTE_DIR"
    fi

elif [ -f "/etc/debian_version" ]; then
    echo -e "${GREEN}Detected Debian/Ubuntu.${NC}"
    sudo apt update
    sudo apt install -y zsh stow git curl

    # Manual installs for tools not in older apt repos
    if ! command -v starship &> /dev/null; then
        curl -sS https://starship.rs/install.sh | sh -s -- -y
    fi
    if ! command -v zoxide &> /dev/null; then
        curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    fi
    # Manual Antidote install
    if [ ! -d "$ANTIDOTE_DIR" ]; then
        git clone --depth=1 https://github.com/mattmc3/antidote.git "$ANTIDOTE_DIR"
    fi
fi

# --- 3. LINK DOTFILES (STOW) ---
echo -e "${BLUE}Linking Dotfiles...${NC}"
if [ -d "$DOTFILES_DIR" ]; then
    cd "$DOTFILES_DIR"
    
    # Clean up default files that might block Stow
    rm -f "$HOME/.zshrc" "$HOME/.bashrc"
    
    # Stow packages
    stow zsh
    mkdir -p "$HOME/.config"
    stow starship
    
    echo -e "${GREEN}Dotfiles linked!${NC}"
else
    echo -e "${RED}Error: ~/dotfiles directory not found.${NC}"
    exit 1
fi

# --- 4. SHELL SETUP ---
# Change shell to Zsh if it isn't already
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Changing default shell to Zsh..."
    chsh -s "$(which zsh)"
fi

echo -e "${GREEN}Success! Restart your terminal to see the changes.${NC}"
