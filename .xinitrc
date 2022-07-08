#!/bin/sh

# The xinit program allows a user to manually start an Xorg display
# server. The startx script is a front-end for xinit.  ~/.xinitrc file
# is sourced when running startx and other programs which call xinit.

# ~/.xinitrc is handy to run programs depending on X and set
# environment variables on X server startup.


# Picom is a standalone compositor use here to get trasparent window
picom &

# feh is a lightweight and powerful image viewer that is used to
# manage the desktop wallpaper
feh --no-fehbg --bg-fill "$HOME/.dotfiles/.config/wallpaper/2545282.jpg" &

# Run the status bar with dwm window manager and status bar can find
# here - https://github.com/BlackcatRs/blackdwm/blob/main/scripts/bar
bar &

# Run window manager dwm
exec dwm

