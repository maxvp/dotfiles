#!/bin/bash
set -e

DOTFILES_DIR="$HOME/.dotfiles"
REPO_URL="git@github.com:maxvp/.dotfiles.git"
FILES_TO_LINK=("zsh/.zshrc" "zsh/.zimrc" "zsh/.zprofile" "zsh/abbrs.zsh" "zsh/aliases.zsh")

echo "🚀 Starting .dotfiles Bootstrap..."

# 1. Clone/Pull
if [ ! -d "$DOTFILES_DIR" ]; then
    git clone "$REPO_URL" "$DOTFILES_DIR"
else
    git -C "$DOTFILES_DIR" pull --rebase
fi

# 2. Set Permissions
chmod +x "$DOTFILES_DIR/scripts/"*.sh

# 3. Symlink
link_file() {
    local src="$DOTFILES_DIR/$1"
    local dest="$HOME/$(basename "$1")"
    [[ -L "$dest" ]] && rm "$dest"
    [[ -f "$dest" ]] && mv "$dest" "$dest.backup"
    ln -s "$src" "$dest"
    echo "   [LINK] $dest -> $src"
}

for file in "${FILES_TO_LINK[@]}"; do
    link_file "$file"
done

# 4. Install Zimfw if missing
if [ ! -d "$HOME/.zim" ]; then
    curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
fi

# 5. Run initial Maintenance
echo "🛠️ Running initial maintenance..."
bash "$DOTFILES_DIR/scripts/maintenance.sh"

echo "✅ Bootstrap complete. Restart terminal or run 'exec zsh'."