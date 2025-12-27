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
abbr -a gcm --position anywhere --set-cursor  "git commit -m "%""
abbr -a gco  "git checkout"
abbr -a gcop "git checkout production"
abbr -a gd   "git diff"
abbr -a gs   "git status"
abbr -a gp   "git push"
abbr -a gl   "git pull"

# --- Maintenance ---
abbr -a zmain "bash $HOME/.dotfiles/scripts/maintenance.sh && exec fish"
abbr -a reload "exec fish"

# --- Utils ---
abbr -a ls "eza --icons --group-directories-first"
abbr -a ll "eza -lh --icons --group-directories-first"
abbr -a la "eza -lah --icons --group-directories-first"
