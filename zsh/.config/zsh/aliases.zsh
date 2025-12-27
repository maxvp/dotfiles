### system
alias zmain="bash $HOME/.dotfiles/scripts/maintenance.sh && exec zsh" # runs shell maintenance script
alias reload="exec zsh"
alias about="fastfetch"
alias neofetch="fastfetch"

### npm
alias nrd="npm run dev"
alias nrb="npm run build"

### git
alias git-recent="git branch --sort=-committerdate"
alias gaa="git add --all"
alias gp="git push"
alias gcp="git checkout production"
alias gco="git checkout"
alias gc="git commit"
alias gcm="git commit -m"

### ls
alias ls="eza"
alias lsa="ls -a"
alias lsla="ls -la"

### unix
alias cat="bat"

### KEEP AT BOTTOM OF LIST
### allow syntax highlighting for abbrs
#alias gc='true'
#alias gco='true'
#alias gcm='true'
#alias gac='true'
