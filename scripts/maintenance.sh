#!/bin/bash
set -e

echo "⚙️ Starting Zsh/Zimfw Maintenance..."

# --- Configuration ---
# Use absolute paths to avoid any ambiguity
DOTFILES_DIR="$HOME/.dotfiles"
ABBRS_FILE="$DOTFILES_DIR/zsh/abbrs.zsh"
ALIASES_FILE="$DOTFILES_DIR/zsh/aliases.zsh"

# Ensure ZIM_HOME is defined and EXPORTED
export ZIM_HOME="${ZIM_HOME:-$HOME/.zim}"

# 0. GIT SYNC
echo "🔄 0. Pulling latest dotfiles..."
if [ -d "$DOTFILES_DIR/.git" ]; then
    git -C "$DOTFILES_DIR" pull --rebase
fi

# 1. ZIMFW UPDATE
echo "📦 1. Updating Zimfw modules..."
if [[ -f "$ZIM_HOME/zimfw.zsh" ]]; then
    # We export it again inside the Zsh call just to be bulletproof
    zsh -c "export ZIM_HOME='$ZIM_HOME'; source '$ZIM_HOME/zimfw.zsh' update"
else
    echo "   [SKIP] zimfw.zsh not found at $ZIM_HOME"
fi

# 2. SYNTAX HIGHLIGHTING SYNC
echo "🎨 2. Syncing Abbreviations -> Dummy Aliases..."
START_MARKER="# --- AUTO-GENERATED ABBR ALIASES START ---"
END_MARKER="# --- AUTO-GENERATED ABBR ALIASES END ---"

touch "$ALIASES_FILE"

# Cross-platform sed logic
if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "/$START_MARKER/,/$END_MARKER/d" "$ALIASES_FILE"
else
    sed -i "/$START_MARKER/,/$END_MARKER/d" "$ALIASES_FILE"
fi

{
    echo "$START_MARKER"
    # Extract keys and generate aliases
    grep -E '^abbr "[^"]+"=' "$ABBRS_FILE" | sed -E 's/abbr "([^"]+)".*/alias \1="true"/'
    echo "$END_MARKER"
} >> "$ALIASES_FILE"

# 3. CLEANUP
echo "🧹 3. Cleaning up compiled files..."
find "$HOME" -name "*.zwc" -delete 2>/dev/null || true

echo "✅ Maintenance Complete!"