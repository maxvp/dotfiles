# 1. Load the Version Control System module
autoload -Uz vcs_info
# Enable parameter expansion in the prompt
setopt prompt_subst

# Configure vcs_info
zstyle ':vcs_info:git:*' check-for-changes true
# %b: branch | %u/%c are handled by prompt_git_counts instead of vcs_info markers
zstyle ':vcs_info:git:*' formats       '%F{242}on%f %F{magenta} %b%f'
zstyle ':vcs_info:git:*' actionformats '%F{242}on%f %F{magenta} %b%f %F{yellow}(%a)%f'

# 2. Function to count staged/unstaged files and ahead/behind status
prompt_git_counts() {
    # Only run if we are in a git repo
    [[ -z $(git rev-parse --is-inside-work-tree 2>/dev/null) ]] && return

    local staged=$(git diff --cached --name-only 2>/dev/null | wc -l | tr -d ' ')
    local dirty=$(git diff --name-only 2>/dev/null | wc -l | tr -d ' ')
    local ahead_behind=$(git rev-list --left-right --count HEAD...@{u} 2>/dev/null)
    
    local status_str=""
    
    # Unstaged (Dirty) count: e.g., *2
    [[ "$dirty" -gt 0 ]] && status_str+=" %F{red}*$dirty%f"
    
    # Staged count: e.g., +1
    [[ "$staged" -gt 0 ]] && status_str+=" %F{green}+$staged%f"
    
    # Ahead/Behind count
    if [[ -n "$ahead_behind" ]]; then
        local ahead=$(echo "$ahead_behind" | awk '{print $1}')
        local behind=$(echo "$ahead_behind" | awk '{print $2}')
        [[ "$ahead" -gt 0 ]] && status_str+=" %F{cyan}↑$ahead%f"
        [[ "$behind" -gt 0 ]] && status_str+=" %F{yellow}↓$behind%f"
    fi

    echo "$status_str"
}

# 3. Refresh info before every prompt display
precmd() {
    vcs_info
    GIT_STATUS_COUNTS=$(prompt_git_counts)
}

# 4. Left Prompt (PROMPT)
# Removed %B (bold start) and %b (bold end)
PROMPT='
%F{blue}%~%f ${vcs_info_msg_0_}${GIT_STATUS_COUNTS}
%(?.%f.%F{red})%%%f '

# 5. Right Prompt (RPROMPT)
# %t is 12-hour format (e.g., 6:08PM)
RPROMPT='%F{242}%t%f'
