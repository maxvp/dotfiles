#!/bin/bash
set -e

DOTFILES_DIR="$HOME/.dotfiles"
PLUGIN_DIR="$DOTFILES_DIR/plugins"
LIST_FILE="$PLUGIN_DIR/plugin_list.txt"

echo "🔄 Syncing Zsh plugins..."
# (Keep your existing plugin loop here)
grep -v '^#' "$LIST_FILE" | grep -v '^$' | while read -r repo; do
    name=$(basename "$repo")
    target="$PLUGIN_DIR/$name"
    if [ ! -d "$target" ]; then
        git clone --depth 1 "https://github.com/$repo.git" "$target"
    else
        git -C "$target" pull --rebase
    fi
done

# NEW: Fish-specific maintenance (if needed)
# Since Fish handles most things natively, you usually just need to update completions
if command -v fish >/dev/null 2>&1; then
    echo "🐟 Updating Fish completions..."
    fish -c "fish_update_completions" > /dev/null 2>&1
fi

# AUTO-COMMIT
if [[ -n $(git -C "$DOTFILES_DIR" status --porcelain) ]]; then
    echo "🚀 Changes detected. Pushing to GitHub..."
    git -C "$DOTFILES_DIR" add .
    git -C "$DOTFILES_DIR" commit -m "Auto-sync: $(date +'%Y-%m-%d')"
    git -C "$DOTFILES_DIR" push
fi

echo "✅ Maintenance complete!"
