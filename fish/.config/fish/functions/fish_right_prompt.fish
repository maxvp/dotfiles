# ~/.dotfiles/fish/.config/fish/functions/fish_right_prompt.fish

function fish_right_prompt
    if test $CMD_DURATION -gt 100
        set -l seconds (math -s2 "$CMD_DURATION / 1000")
        set_color 929292
        echo -n "$seconds"s
        set_color normal
    end
end
