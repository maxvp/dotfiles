#!/bin/bash
set -e

# 1. Install Dependencies
if [[ "$(uname)" == "Darwin" ]]; then
    command -v stow >/dev/null 2>&1 || brew install stow
fi

echo "🔗 Preparing symlinks..."

# 2. PRE-FLIGHT BACKUP
# Generate timestamp: 20251224
TIMESTAMP=$(date +%Y%m%d)

# Files that Stow will manage in the home directory
FILES_TO_CHECK=(".zshrc" ".zprofile" "aliases.zsh")

for file in "${FILES_TO_CHECK[@]}"; do
    TARGET="$HOME/$file"
    
    # If it's a real file (not a symlink), rename it
    if [[ -f "$TARGET" && ! -L "$TARGET" ]]; then
        BACKUP_NAME="${TARGET}.backup-${TIMESTAMP}"
        echo "   [BACKUP] Moving real file $file to $(basename "$BACKUP_NAME")"
        mv "$TARGET" "$BACKUP_NAME"
    fi
done

# 3. RUN STOW
# Run from the dotfiles root so Stow knows where the 'packages' are
cd "$HOME/.dotfiles"
echo "📦 Stowing packages..."
stow -v zsh
stow -v scripts

# 4. INITIAL MAINTENANCE
bash "$HOME/.dotfiles/scripts/maintenance.sh"

echo "✅ System ready. Run 'exec zsh' to apply changes."