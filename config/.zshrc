# Set the ZDOTDIR variable to the standard XDG config location
# This tells Zsh where to look for startup files like .zshenv, .zshrc, etc.
export ZDOTDIR="$HOME/.config/zsh"

# Source the primary Zsh configuration file
source "${ZDOTDIR}/.zshrc_main"
