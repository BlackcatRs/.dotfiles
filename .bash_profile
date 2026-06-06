# If bashrc file exist then load it
[[ -f "$HOME/.bashrc" ]] && source "$HOME/.bashrc"

# Start graphical server on user's current tty if not already running.
if [[ "$(tty)" = "/dev/tty1" ]]; then
    pgrep startx || startx 
fi
