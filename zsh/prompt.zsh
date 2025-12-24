# 1. Logic to get Git info
# This function is called every time a new prompt is rendered
prompt_git() {
  # Check if we are in a git repo
  local branch=$(git branch --show-current 2>/dev/null)
  if [[ -n $branch ]]; then
    # Print 'on' in gray, branch in magenta with a Nerd Font icon
    echo "%F{242}on%f %F{magenta} $branch%f"
  fi
}

# 2. Logic to show the last command's exit code
# If a command fails, show a red X; otherwise, stay silent.
prompt_status() {
  echo "%(?..%F{red}✕ %f)"
}

# 3. Define the PROMPT
# %B/%b: Bold start/end
# %n: Username
# %~: Current directory (relative to home)
# \n: New line for that "grid" layout
PROMPT='
%B%F{cyan}%n%f%b %B%F{blue}%~%f%b $(prompt_git)
$(prompt_status)λ '

# 4. Define the RPROMPT (Right side)
RPROMPT='%F{242}%t%f'