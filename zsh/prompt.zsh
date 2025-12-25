# 1. Load the Version Control System module
autoload -Uz vcs_info
setopt prompt_subst

# Configure vcs_info formats
# %b: branch
# %u: unstaged/dirty (red dot)
# %c: staged (green plus)
zstyle ':vcs_info:git:*' formats       'on %F{magenta} %b%f%F{red}%u%f%F{green}%c%f'
zstyle ':vcs_info:git:*' actionformats 'on %F{magenta} %b%f %F{yellow}(%a)%f%F{red}%u%f%F{green}%c%f'
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr ' ●'
zstyle ':vcs_info:git:*' stagedstr ' ✚'

# 2. Refresh git info before every prompt display
precmd() {
    vcs_info
}

# 3. Left Prompt (PROMPT)
# Top line: Directory + Git info
# Bottom line: Status indicator + Lambda
PROMPT='
%B%F{blue}%~%f%b ${vcs_info_msg_0_}
%(?.%F{magenta}.%F{red})λ%f '

# 4. Define the RPROMPT (Right side)
RPROMPT='%F{242}%t%f'

