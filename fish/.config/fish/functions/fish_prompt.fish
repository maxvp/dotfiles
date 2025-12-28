function __styled_pwd
    set -l parts (string split / (prompt_pwd))
    set -l last (count $parts)

    for i in (seq 1 $last)
        if test $i -lt $last
            set_color brblack
        else
            set_color blue
        end
        echo -n $parts[$i]
        test $i -lt $last; and echo -n '/'
    end

    set_color normal
end


function fish_prompt
    set -l last_status $status

    test $last_status -ne 0; and set_color red; or set_color normal
    echo -n "λ "
    set_color normal
end
