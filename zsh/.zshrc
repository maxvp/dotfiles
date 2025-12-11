# ~/.zshrc

# --- 1. GLOBAL PATH CONFIGURATION (Must be first) ---
typeset -U path PATH
path=(
    "$HOME/.local/bin"
    "$HOME/bin"
    "/usr/local/bin"
    $path
)

# Robustly find Homebrew (Works on both Apple Silicon and Intel)
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi
export PATH

# --- 2. ANTIDOTE SOURCE (Load Antidote's functions) ---
# Check common install locations (Apple Silicon, Intel, Linux, Manual)
if [[ -f /opt/homebrew/share/antidote/antidote.zsh ]]; then
    source /opt/homebrew/share/antidote/antidote.zsh
elif [[ -f /usr/local/share/antidote/antidote.zsh ]]; then
    source /usr/local/share/antidote/antidote.zsh
elif [[ -f /usr/share/zsh-antidote/antidote.zsh ]]; then
    source /usr/share/zsh-antidote/antidote.zsh
elif [[ -f ${ZDOTDIR:-~}/.antidote/antidote.zsh ]]; then
    source ${ZDOTDIR:-~}/.antidote/antidote.zsh
fi

# --- 3. COMPLETION SYSTEM (Crucial: Must be before antidote load) ---
# This enables the 'compdef' command that the git plugin needs.
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' # Case insensitive
zstyle ':completion:*' menu select                     # Menu select

# --- 4. ANTIDOTE LOAD PLUGINS ---
antidote load ${ZDOTDIR:-~}/.zsh_plugins.txt

# --- 5. BASIC CONFIG ---
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY
bindkey -e

# --- 6. UI & PROMPT ---
# zoxide should be installed via brew/pacman
eval "$(starship init zsh)"
# eval "$(zoxide init zsh)" # Only needed if zoxide is installed

# --- 7. ABBREVIATIONS ---
abbr -S -q g="git"
abbr -S -q lg="lazygit"
alias nrd="npm run dev"
alias git-recent="git branch --sort=-committerdate"
alias gaa="git add --all"
unalias gp
alias gp="git push"
alias gcp="git checkout production"
abbr -S -q gaacm="git add --all && git commit -m "%""
abbr -S -q gc="git commit"
abbr -S -q gcm="git commit -m "%""
abbr -S -q gco="git checkout"
