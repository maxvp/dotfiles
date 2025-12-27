# ~/.dotfiles/fish/.config/fish/conf.d/abbrs.fish
# abbreviations

# Clean up existing abbrs to prevent duplicates on reload
for a in (abbr -l)
    abbr -e $a
end

# --- Git ---
abbr -a ga   "git add"
abbr -a gaa  "git add --all"
abbr -a gc   "git commit"
abbr -a gcm  --set-cursor  'git commit -m "%"'
abbr -a gco  "git checkout"
abbr -a gcop "git checkout production"
abbr -a gd   "git diff"
abbr -a gs   "git status"
abbr -a gp   "git push"
abbr -a gl   "git pull"

# --- Maintenance ---
## maintenance script
abbr -a zmain "bash $HOME/.dotfiles/scripts/maintenance.sh && exec fish"
## switch shells
abbr -a tozsh "chsh -s $(which zsh) && echo 'Switched to zsh. Restart terminal.'"
abbr -a reload "exec fish"

# --- Utils ---
abbr -a ls "eza"
abbr -a lsa "eza -a"
abbr -a ll "eza -lh --group-directories-first"
abbr -a la "eza -lah --group-directories-first"

# --- zsh shortcuts ---
# Last command
abbr -a !! --position anywhere --function last_history_item

# Last argument of last command
abbr -a '!$' --position anywhere --function last_history_arg

# Helper functions for the abbreviations
function last_history_item
    echo $history[1]
end

function last_history_arg
    echo $argv_history[1] # Note: older fish might need: echo (commandline -poc)[-1]
end
