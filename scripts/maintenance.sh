#!/bin/bash
set -e

echo "⚙️ Starting Zsh/Zimfw Maintenance..."

# --- Configuration ---
DOTFILES_DIR="$HOME/.dotfiles"
ABBRS_FILE="$DOTFILES_DIR/zsh/abbrs.zsh"
ALIASES_FILE="$DOTFILES_DIR/zsh/aliases.zsh"
export ZIM_HOME="${ZIM_HOME:-$HOME/.zim}"

# 0. DOCTOR CHECK
echo "🩺 0. Running Doctor Checks..."
if [[ ! -L "$HOME/.zshrc" ]]; then
    echo "   [ERR] .zshrc is not a symlink! Run bootstrap.sh."
fi

# 1. GIT SYNC
echo "🔄 1. Pulling latest changes..."
git -C "$DOTFILES_DIR" pull --rebase

# 2. ZIMFW UPDATE
echo "📦 2. Updating Zimfw..."
if [[ -f "$ZIM_HOME/zimfw.zsh" ]]; then
    zsh -c "export ZIM_HOME='$ZIM_HOME'; source '$ZIM_HOME/zimfw.zsh' update" || echo "⚠️ Zimfw update failed."
fi

# 3. SYNTAX HIGHLIGHTING SYNC (Atomic Swap)
echo "🎨 3. Syncing Abbrs to Aliases..."
TEMP_ALIASES=$(mktemp)
START_MARKER="# --- AUTO-GENERATED ABBR ALIASES ---"

echo "$START_MARKER" > "$TEMP_ALIASES"
if [[ -f "$ABBRS_FILE" ]]; then
    grep -E '^abbr "[^"]+"=' "$ABBRS_FILE" | sed -E 's/abbr "([^"]+)".*/alias \1="true"/' >> "$TEMP_ALIASES"
fi
mv "$TEMP_ALIASES" "$ALIASES_FILE"

# 4. CLEANUP
find "$HOME" -name "*.zwc" -delete 2>/dev/null || true

echo "✅ Maintenance complete!"