# --- 1. COMPLETION SYSTEM ---
# Initialize completion system with performance caching
autoload -Uz compinit
zmodload zsh/complist

# Only re-generate completion dump if it's older than 24h
for dump in "${HOME}/.zcompdump"(N.mh+24); do
  compinit
done
compinit -C

# Completion Menu & Style
zstyle ':completion:*' menu yes select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Completion Options
_comp_options+=(globdots)       # Include hidden files in completion
zle_highlight=('paste:none')    # Disable highlighting during paste

# --- 2. SHELL OPTIONS (UX) ---
unsetopt BEEP                   # No annoying beeps
setopt AUTO_CD                  # 'documents' instead of 'cd documents'
setopt GLOB_DOTS                # '*' includes hidden files
setopt NOMATCH                  # Don't error if a wildcard finds nothing
setopt MENU_COMPLETE            # Highlight first item in completion menu
setopt EXTENDED_GLOB            # Use #, ^, and ~ for advanced matching
setopt INTERACTIVE_COMMENTS     # Allow comments in interactive shell
setopt APPEND_HISTORY           # Don't overwrite history file
setopt prompt_subst             # Allow color in prompt

# --- 3. HISTORY CONFIGURATION ---
HISTFILE="${HOME}/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

setopt BANG_HIST                # Treat '!' specially
setopt EXTENDED_HISTORY         # Record timestamp in history
setopt INC_APPEND_HISTORY       # Write to history immediately
setopt SHARE_HISTORY            # Share history between sessions
setopt HIST_EXPIRE_DUPS_FIRST   # Trim duplicates first
setopt HIST_IGNORE_DUPS         # Don't record same command twice in a row
setopt HIST_IGNORE_ALL_DUPS     # Clean duplicates from entire history
setopt HIST_FIND_NO_DUPS        # Don't show duplicates when searching
setopt HIST_IGNORE_SPACE        # Commands starting with space aren't saved
setopt HIST_SAVE_NO_DUPS        # Don't save duplicates to file
setopt HIST_REDUCE_BLANKS       # Remove extra whitespace
setopt HIST_VERIFY              # Show expansion before running

# --- 4. KEYBINDINGS & WIDGETS ---
# History Search: Type 'git' + Up Arrow to find previous git commands
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

# Standard Mac/Linux expected keys
bindkey '^H' backward-kill-word             # Ctrl+Backspace to delete word
bindkey -s '^x' '^usource ~/.zshrc\n'       # Ctrl+X to reload shell

# Menu Select Search (Search within tab-completion list)
bindkey -M menuselect '?' history-incremental-search-forward
bindkey -M menuselect '/' history-incremental-search-backward

# --- 5. COLORS & PATHS ---
autoload -Uz colors && colors
export PATH="$HOME/.local/bin:$PATH"

# OS Specific LS/EZA Logic
if command -v eza >/dev/null 2>&1; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -lh --icons --group-directories-first'
    alias la='eza -lah --icons --group-directories-first'
else
    case "$(uname -s)" in
        Darwin) alias ls='ls -G' ;;
        Linux)  alias ls='ls --color=auto' ;;
    esac
fi