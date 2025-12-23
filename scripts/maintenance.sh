#!/bin/bash
set -e

echo "⚙️ Starting Zsh/Zimfw Maintenance & Health Check..."

# --- Configuration ---
DOTFILES_DIR="$HOME/.dotfiles"
ABBRS_FILE="$DOTFILES_DIR/zsh/abbrs.zsh"
ALIASES_FILE="$DOTFILES_DIR/zsh/aliases.zsh"
export ZIM_HOME="${ZIM_HOME:-$HOME/.zim}"

# 0. DOCTOR CHECK (Health Diagnostic)
echo "🩺 0. Running Doctor Checks..."

# Check for uncommitted changes
if [[ -n $(git -C "$DOTFILES_DIR" status --porcelain) ]]; then
    echo "   [WARN] You have uncommitted changes in .dotfiles. Syncing might cause conflicts."
else
    echo "   [OK] Git directory is clean."
fi

# Check symlinks
for file in ".zshrc" ".zimrc" "abbrs.zsh"; do
    if [[ ! -L "$HOME/$file" ]]; then
        echo "   [ERR] $file is not a symlink! Run bootstrap.sh to fix."
    fi
done

# Check Zsh version (Zimfw prefers 5.2+)
ZSH_VER=$(zsh --version | awk '{print $2}')
echo "   [OK] Zsh version $ZSH_VER detected."

# 1. GIT SYNC
echo "🔄 1. Pulling latest changes..."
git -C "$DOTFILES_DIR" pull --rebase

# 2. ZIMFW UPDATE
echo "📦 2. Updating Zimfw..."
if [[ -f "$ZIM_HOME/zimfw.zsh" ]]; then
    zsh -c "export ZIM_HOME='$ZIM_HOME'; source '$ZIM_HOME/zimfw.zsh' update"
else
    echo "   [SKIP] zimfw.zsh not found at $ZIM_HOME"
fi

# 3. SYNTAX HIGHLIGHTING SYNC
echo "🎨 3. Syncing Abbrs to Aliases..."
START_MARKER="# --- AUTO-GENERATED ABBR ALIASES START ---"
END_MARKER="# --- AUTO-GENERATED ABBR ALIASES END ---"

touch "$ALIASES_FILE"

if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "/$START_MARKER/,/$END_MARKER/d" "$ALIASES_FILE"
else
    sed -i "/$START_MARKER/,/$END_MARKER/d" "$ALIASES_FILE"
fi

{
    echo "$START_MARKER"
    grep -E '^abbr "[^"]+"=' "$ABBRS_FILE" | sed -E 's/abbr "([^"]+)".*/alias \1="true"/'
    echo "$END_MARKER"
} >> "$ALIASES_FILE"

# 4. CLEANUP
echo "🧹 4. Cleaning up caches..."
find "$HOME" -name "*.zwc" -delete 2>/dev/null || true

echo "✅ Maintenance complete!"