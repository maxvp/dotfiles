# ~/.dotfiles/fish/.config/fish/functions/fish_prompt.fish

function fish_prompt
    set -l last_status $status

    # Configure the internal git prompt behavior
    set -g __fish_git_prompt_showdirtystate 1
    set -g __fish_git_prompt_showstagedstate 1
    set -g __fish_git_prompt_showuntrackedfiles 1
    set -g __fish_git_prompt_color_branch magenta
    set -g __fish_git_prompt_char_stateseparator ' '

    echo 
    set_color blue
    echo -n (prompt_pwd)
    set_color normal

    # Use the high-performance internal git prompt
    printf '%s ' (fish_vcs_prompt)

    echo
    test $last_status -ne 0; and set_color red; or set_color normal
    echo -n "λ "
    set_color normal
end
