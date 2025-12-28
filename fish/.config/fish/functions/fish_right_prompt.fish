function __git_info
    command git rev-parse --is-inside-work-tree >/dev/null 2>&1; or return

    set -l branch (command git symbolic-ref --short HEAD 2>/dev/null \
        || command git rev-parse --short HEAD 2>/dev/null)

    set -l status (command git status --porcelain=2 --branch 2>/dev/null)

    set -l staged   (string match -r '^1 ' $status | count)
    set -l unstaged (string match -r '^2 ' $status | count)

    set -l ahead  (string match -r 'ahead ([0-9]+)'  $status | string replace -r '.* ' '')
    set -l behind (string match -r 'behind ([0-9]+)' $status | string replace -r '.* ' '')

    set -l out "$branch"

    test $staged   -gt 0; and set out "$out +$staged"
    test $unstaged -gt 0; and set out "$out ~$unstaged"
    test -n "$ahead";  and set out "$out ↑$ahead"
    test -n "$behind"; and set out "$out ↓$behind"

    echo $out
end


function fish_right_prompt
    set -g fish_prompt_pwd_dir_length 3

    set_color blue
    echo -n (prompt_pwd)
    set_color normal

    set -l git (__git_info)
    test -n "$git"; and echo -n " $git"
end
