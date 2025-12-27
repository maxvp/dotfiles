# ~/.dotfiles/fish/.config/fish/functions/fish_prompt.fish

function fish_prompt
    set -l last_status $status

    # 1. Newline for "Grid" effect
    echo

    # 2. Path (Blue)
    set_color blue
    echo -n (prompt_pwd)
    set_color normal
    echo -n " "

    # 3. Git Info (Magenta, Gray "on")
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1
        set_color 929292
        echo -n "on "
        set_color magenta
        echo -n " "
        echo -n (git branch --show-current 2>/dev/null)
        set_color normal
        
        # Git Dirty/Staged Logic
        set -l dirty (git diff --name-only 2>/dev/null | wc -l | tr -d ' ')
        set -l staged (git diff --cached --name-only 2>/dev/null | wc -l | tr -d ' ')
        
        if test "$dirty" -gt 0
            set_color red
            echo -n " *$dirty"
        end
        if test "$staged" -gt 0
            set_color green
            echo -n " +$staged"
        end
    end

    # 4. Lambda (Red on error, Normal otherwise)
    echo
    if test $last_status -ne 0
        set_color red
    else
        set_color normal
    end
    echo -n "λ "
    set_color normal
end
