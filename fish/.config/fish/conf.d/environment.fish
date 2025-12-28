# ~/.dotfiles/fish/.config/fish/conf.d/environment.fish
# PATH environment variables

# Homebrew (Silicon)
# Only evaluate if the binary exists to avoid errors on non-Macs
if test -f /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv)
end

# Local Binaries
fish_add_path -m ~/.local/bin
fish_add_path -m ~/bin

## Volta
set -gx VOLTA_HOME "$HOME/.volta"
fish_add_path -m "$VOLTA_HOME/bin"

## Windsurf
fish_add_path -m "$HOME/.codeium/windsurf/bin"

## VS Code
fish_add_path -m "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# Editors
set -gx EDITOR micro
set -gx VISUAL micro

# Homebrew
set -gx HOMEBREW_NO_ANALYTICS 1

# git prompt
set -gx __fish_git_prompt_show_informative_status 1

## colors
set -gx __fish_git_prompt_color_branch magenta
set -gx __fish_git_prompt_color_stagedstate green
set -gx __fish_git_prompt_color_dirtystate red
set -gx __fish_git_prompt_color_untrackedfiles yellow
set -gx __fish_git_prompt_color_invalidstate brred

## symbols
set -gx __fish_git_prompt_char_stateseparator ' '
set -gx __fish_git_prompt_char_dirtystate '*'
set -gx __fish_git_prompt_char_stagedstate '+'
set -gx __fish_git_prompt_char_untrackedfiles '?'
set -gx __fish_git_prompt_char_cleanstate ''
set -gx __fish_git_prompt_char_prefix ''
set -gx __fish_git_prompt_char_suffix ''

## Pure prompt
set -gx pure_symbol_git_dirty '*'
set -gx pure_symbol_git_unpulled_commits '↓'
set -gx pure_symbol_git_unpushed_commits '↑'
set -gx pure_show_numbered_git_indicator true
