# --- PROMPT ---
PROMPT='%n@%m %~ λ '

# --- PLUGINS ---
if [[ -d "$HOME/.dotfiles/plugins" ]]; then
    for plugin in $HOME/.dotfiles/plugins/*/*.plugin.zsh(N) $HOME/.dotfiles/plugins/*/*.zsh(N); do
        # Skip syntax highlighting to load it last
        [[ "$plugin" == *"zsh-syntax-highlighting"* ]] && continue
        # Skip abbr if it's still hanging around
        [[ "$plugin" == *"zsh-abbr"* ]] && continue
        source "$plugin"
    done
fi

# --- STANDARD ALIASES ---
# We source a manual aliases file instead of a generated one
[[ -f "$HOME/.dotfiles/zsh/aliases.zsh" ]] && source "$HOME/.dotfiles/zsh/aliases.zsh"

# --- SYNTAX HIGHLIGHTING (Last) ---
[[ -f "$HOME/.dotfiles/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
    source "$HOME/.dotfiles/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# --- UTILITIES ---
alias zmain="bash $HOME/.dotfiles/scripts/maintenance.sh && exec zsh"