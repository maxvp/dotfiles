#!/bin/bash
set -e

echo "🍺 Starting macOS App Setup..."

# 1. Install Homebrew if missing
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for the current session (Apple Silicon & Intel)
    if [[ "$(uname -m)" == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo "✅ Homebrew already installed."
fi

# 2. Run the Brewfile
BREWFILE="$HOME/.dotfiles/install/Brewfile"
if [[ -f "$BREWFILE" ]]; then
    echo "📦 Installing apps from Brewfile..."
    brew bundle --file="$BREWFILE"
else
    echo "❌ Brewfile not found at $BREWFILE"
fi

echo "✅ Mac setup complete!"