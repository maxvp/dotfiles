#!/bin/bash
set -e

DOTFILES_DIR="$HOME/.dotfiles"
PLUGIN_DIR="$DOTFILES_DIR/plugins"
LIST_FILE="$PLUGIN_DIR/plugin_list.txt"

echo "🔄 Syncing plugins from list..."

# Read the file, ignore comments and empty lines
grep -v '^#' "$LIST_FILE" | grep -v '^$' | while read -r repo; do
    name=$(basename "$repo")
    target="$PLUGIN_DIR/$name"

    if [ ! -d "$target" ]; then
        echo "   [NEW] Cloning $repo..."
        git clone --depth 1 "https://github.com/$repo.git" "$target"
    else
        echo "   [UP]  Updating $name..."
        git -C "$target" pull --rebase
    fi
done

# AUTO-COMMIT (Optional, keeps your repo in sync)
if [[ -n $(git -C "$DOTFILES_DIR" status --porcelain) ]]; then
    echo "🚀 Changes detected. Pushing to GitHub..."
    git -C "$DOTFILES_DIR" add .
    git -C "$DOTFILES_DIR" commit -m "Auto-sync: updated plugins $(date +'%Y-%m-%d')"
    git -C "$DOTFILES_DIR" push
fi

echo "✅ Maintenance complete!"