# ~/.dotfiles/fish/.config/fish/config.fish

if status is-interactive
    # Remove the default login message
    set -g fish_greeting

    # Initialize Starship (If you use it)
    # starship init fish | source

    # Initialize Zoxide (Smarter 'cd')
#    if type -q zoxide
#        zoxide init fish | source
#    end
end
