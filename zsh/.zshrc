# --- PROMPT ---
PROMPT='%F{cyan}%n%f@%m %B%F{blue}%~%f%b λ '

# --- OPTIONS ---
source "$HOME/.dotfiles/zsh/options.zsh"

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

# --- ALIASES ---
# We source a manual aliases file instead of a generated one
[[ -f "$HOME/.dotfiles/zsh/aliases.zsh" ]] && source "$HOME/.dotfiles/zsh/aliases.zsh"

# --- SYNTAX HIGHLIGHTING (place last) ---
[[ -f "$HOME/.dotfiles/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
    source "$HOME/.dotfiles/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
