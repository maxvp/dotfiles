#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status.

# --- Configuration ---
DOTFILES_DIR="$HOME/.dotfiles"
REPO_URL="git@github.com:maxvp/.dotfiles.git"
FILES_TO_LINK=(
    "zsh/.zshrc"
    "zsh/.zimrc"
    "zsh/.zprofile"
    "zsh/abbrs.zsh"
)

echo "🚀 Starting Universal .dotfiles Bootstrap..."
echo "---"

# --- 1. Platform and Package Manager Detection ---

# Define system variables
OS=$(uname -s)
ARCH=$(uname -m)
PKG_MANAGER=""
INSTALL_CMD=""

# Function to find the package manager and set the install command
find_package_manager() {
    if [[ "$OS" == "Darwin" ]]; then
        # macOS: Use Homebrew
        PKG_MANAGER="Homebrew"
        if ! command -v brew > /dev/null 2>&1; then
            echo "⚠️ Homebrew not found. Installing Homebrew..."
            # Install Homebrew (Note: this is a complex install, often requiring user confirmation)
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            # Ensure brew is in PATH for the rest of the script
            eval "$(/opt/homebrew/bin/brew shellenv)" || true
        fi
        INSTALL_CMD="brew install"

    elif [[ "$OS" == "Linux" ]]; then
        # Linux: Detect common package managers
        if command -v apt-get > /dev/null 2>&1; then
            PKG_MANAGER="APT (Debian/Ubuntu)"
            INSTALL_CMD="sudo apt-get install -y"
            sudo apt-get update
        elif command -v dnf > /dev/null 2>&1; then
            PKG_MANAGER="DNF (Fedora/RHEL)"
            INSTALL_CMD="sudo dnf install -y"
        elif command -v pacman > /dev/null 2>&1; then
            PKG_MANAGER="Pacman (Arch)"
            INSTALL_CMD="sudo pacman -S --noconfirm"
            sudo pacman -Sy
        else
            echo "❌ ERROR: No supported package manager (apt, dnf, pacman) found on Linux."
            exit 1
        fi
    else
        echo "❌ ERROR: Unsupported OS ($OS). Exiting."
        exit 1
    fi
}

# --- 2. Zsh Installation ---

install_zsh() {
    if ! command -v zsh > /dev/null 2>&1; then
        echo "⚙️ Zsh not found. Installing via $PKG_MANAGER..."

        # Specific fix for Homebrew on Intel Mac (not strictly necessary but good practice)
        if [[ "$OS" == "Darwin" && "$ARCH" == "x86_64" ]]; then
             # On Intel Macs, the default zsh is /bin/zsh, but Homebrew zsh is preferred
             # We install, and the chsh step below will update the path.
             $INSTALL_CMD zsh
        else
            $INSTALL_CMD zsh
        fi
    else
        echo "✅ Zsh is already installed."
    fi
}

# Execute detection and installation
find_package_manager
install_zsh

# --- 3. Repository Cloning and Symlinks (Standard Logic) ---

echo "---"
# Clone the repository
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "📦 Cloning .dotfiles from $REPO_URL..."
    git clone "$REPO_URL" "$DOTFILES_DIR"
else
    echo "✅ Dotfiles repository already present at $DOTFILES_DIR."
    echo "Pulling latest changes..."
    (cd "$DOTFILES_DIR" && git pull)
fi

# Symlink Function
link_file() {
    local src="$DOTFILES_DIR/$1"
    local dest="$HOME/$(basename "$1")"

    if [ ! -f "$src" ]; then
        echo "   [SKIP] Source file not found in repo: $src"
        return
    fi

    if [ -e "$dest" ]; then
        if [ -L "$dest" ] && [ "$(readlink "$dest")" == "$src" ]; then
            echo "   [OK] $dest is already correctly linked."
            return
        else
            echo "   [BACKUP] Backing up existing $dest to $dest.backup"
            mv "$dest" "$dest.backup"
        fi
    fi

    echo "   [LINK] Creating symlink $dest -> $src"
    ln -s "$src" "$dest"
}

# Create Symlinks for Zsh config files
echo "---"
echo "🔗 Creating Symbolic Links:"
for file in "${FILES_TO_LINK[@]}"; do
    link_file "$file"
done

# --- 4. Change Default Shell ---

# Use `which zsh` to get the correct path installed by the package manager
ZSH_PATH=$(which zsh)
if [ -n "$ZSH_PATH" ]; then
    if [ "$SHELL" != "$ZSH_PATH" ]; then
        echo "---"
        echo "🐚 Changing default shell to Zsh ($ZSH_PATH)..."
        chsh -s "$ZSH_PATH"
        echo "ℹ️ You may need to enter your user password to change the shell."
    else
        echo "---"
        echo "✅ Default shell is already Zsh."
    fi
fi

echo "---"
echo "🎉 Bootstrap Complete! Your dotfiles are linked and Zsh is set as your default shell."

# --- PAUSE AND RESTART PROMPT ---
if [[ -n "$ZSH_PATH" && "$SHELL" != "$ZSH_PATH" ]]; then
    # Only show this prompt if the shell was actually changed.
    echo "⚠️  Please **RESTART YOUR TERMINAL** now to apply the Zsh default shell change."
else
    # Show a general restart prompt if the shell was already Zsh.
    echo "ℹ️  Restart your terminal to load the newly configured Zim environment."
fi

# Simple pause to allow the user to read the success message and prompt.
read -p "Press [Enter] to exit the bootstrap script..."
exit 0
