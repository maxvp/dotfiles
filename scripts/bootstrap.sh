#!/bin/bash
set -e

# 1. Install Dependencies
if [[ "$(uname)" == "Darwin" ]]; then
    command -v stow >/dev/null 2>&1 || brew install stow
fi

echo "🔗 Preparing symlinks..."

# 2. PRE-FLIGHT BACKUP (Updated for XDG structure)
TIMESTAMP=$(date +%Y%m%d)

# We now only care about the pointer file in $HOME
# because the rest are hidden in ~/.config
FILES_TO_CHECK=(".zshenv") 

for file in "${FILES_TO_CHECK[@]}"; do
    TARGET="$HOME/$file"
    if [[ -f "$TARGET" && ! -L "$TARGET" ]]; then
        BACKUP_NAME="${TARGET}.backup-${TIMESTAMP}"
        echo "   [BACKUP] Moving real file $file to $(basename "$BACKUP_NAME")"
        mv "$TARGET" "$BACKUP_NAME"
    fi
done

# 3. RUN STOW
cd "$HOME/.dotfiles"
echo "📦 Stowing packages..."
stow -v zsh
stow -v fish    # Added Fish
stow -v scripts

# 4. INITIAL MAINTENANCE
bash "$DOTFILES_DIR/scripts/maintenance.sh"

echo "✅ System ready."
echo "   - For Zsh: Run 'exec zsh'"
echo "   - For Fish: Run 'fish'"
