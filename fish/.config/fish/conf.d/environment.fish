# ~/.dotfiles/fish/.config/fish/conf.d/environment.fish
# PATH environment variables

# 1. Homebrew (Silicon)
# Only evaluate if the binary exists to avoid errors on non-Macs
if test -f /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv)
end

# 2. Local Binaries
fish_add_path -m ~/.local/bin
fish_add_path -m ~/bin

# 3. Editors
set -gx EDITOR micro
set -gx VISUAL micro
