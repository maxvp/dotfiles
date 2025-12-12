# ~/.zprofile

# Suppress the "Last login" message
if [[ -f "$HOME/.hushlogin" ]]; then
    # If .hushlogin exists, the shell automatically suppresses the banner
    : # Do nothing
else
    # Otherwise, create it now (it's an empty file)
    touch "$HOME/.hushlogin"
fi