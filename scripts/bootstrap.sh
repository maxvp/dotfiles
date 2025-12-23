#!/bin/bash
set -e

# --- Configuration ---
DOTFILES_DIR="$HOME/.dotfiles"
REPO_URL="https://github.com/maxvp/.dotfiles.git"
FILES_TO_LINK=(
    "zsh/.zshrc"
    "zsh/.zimrc"
    "zsh/.zprofile"
    "zsh/abbrs.zsh"
)

echo "🚀 Starting .dotfiles Bootstrap..."

# 1. Clone or Pull Repo
if [ ! -d "$DOTFILES_DIR" ]; then
    git clone "$REPO_URL" "$DOTFILES_DIR"
else
    git -C "$DOTFILES_DIR" pull --rebase
fi

# 2. Set Permissions for scripts
chmod +x "$DOTFILES_DIR/scripts/"*.sh

# 3. NUCLEAR SYMLINKING (Force Link)
echo "🔗 Forcing symbolic links..."
for file in "${FILES_TO_LINK[@]}"; do
    TARGET="$HOME/$(basename "$file")"
    rm -rf "$TARGET"
    ln -s "$DOTFILES_DIR/$file" "$TARGET"
    echo "   [FORCE LINK] $TARGET -> $file"
done

# 4. Zimfw Check & Install
if [[ ! -d "$HOME/.zim" ]]; then
    echo "📦 Installing Zimfw..."
    curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
fi

# 5. Run initial Maintenance (Generates aliases.zsh)
bash "$DOTFILES_DIR/scripts/maintenance.sh"

echo "✅ Bootstrap complete! Run 'exec zsh'."