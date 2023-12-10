#!/usr/bin/env bash

#####################################################################################################
# TODO Intel microcode
sudo pacman -S intel-ucode # if AMD amd-ucode

#####################################################################################################
# Package need by .dotfiles
sudo pacman -S exa stow gpg emacs ranger

#####################################################################################################
# Themes
sudo pacman gnome-themes-extra kvantum papirus-icon-theme lxappearance qt5ct

#####################################################################################################
# TODO Fonts
# On Arch, the noto fonts for "everything" are split into:

# noto-fonts for Roman, Greek, Cyrillic and probably some other alphabets, along with ASCII art nonsense and numbers and punctuation and stuff and I think some rudimentary Japanese and Chinese(?);
# noto-fonts-emoji for emoji;
# noto-fonts-cjk for Chinese, Japanese, and Korean characters (all of them); and
# noto-fonts-extra for god knows what, I haven't looked.
# With those four installed, you should always have an arbitrary character render properly. 

#####################################################################################################
# TODO Firfox
# Starting with Firefox 68, you can make all the Firefox interfaces and even other websites respect dark themes, irrespective of the system GTK theme and Firefox theme. To do this, set ui.systemUsesDarkTheme to 1 in about:config [13]. 

#####################################################################################################
# Keyboard Conf
echo "Section "InputClass"
    Identifier "keyboard defaults"
    MatchIsKeyboard "on"

    # Option "XKbOptions" "ctrl:swapcaps"
    Option "XKbOptions" "ctrl:nocaps"
EndSection
" > /etc/X11/xorg.conf.d/90-custom-kbd.conf

#####################################################################################################
# TODO Remove file (if exist)
rm ~/.bash_profile ~/.bashrc

#####################################################################################################
# Install color scirpts
cd ./shell-color-scripts && make clean install

# Install startship promt
curl -sS https://starship.rs/install.sh | sh

#####################################################################################################
# Package to install for i3 vm
sudo pacman -S xorg-xinit xorg-server i3-wm i3status
cp /etc/X11/xinit/xinitrc ~/.xinitrc

# TODO remote some lines at bottom
echo 'exec i3' >> ~/.xinitrc

#####################################################################################################
### Show which comman has been executed
set -e

function insall_stow() {
    is_exist=`stow -V`
    if [ $is_exist -ne 0 ]
    then
	pacman -S stow
    fi
}

#####################################################################################################
function isRoot() {
    if [[ $(id -u) -ne 0 ]]
    then
	echo "Please run as root"
	exit 1
    fi
}

#####################################################################################################
echo "Setting up Noto Emoji font..."

# 1 - install  noto-fonts-emoji package
pacman -S noto-fonts-emoji --needed

# pacman -S powerline-fonts --needed
echo "Recommended system font: inconsolata regular (ttf-inconsolata or powerline-fonts)"

# # 2 - add font config to /etc/fonts/conf.d/01-notosans.conf
# echo "<?xml version="1.0"?>
# <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
# <fontconfig>
#  <alias>
#    <family>sans-serif</family>
#    <prefer>
#      <family>Noto Sans</family>
#      <family>Noto Color Emoji</family>
#      <family>Noto Emoji</family>
#      <family>DejaVu Sans</family>
#    </prefer> 
#  </alias>

#  <alias>
#    <family>serif</family>
#    <prefer>
#      <family>Noto Serif</family>
#      <family>Noto Color Emoji</family>
#      <family>Noto Emoji</family>
#      <family>DejaVu Serif</family>
#    </prefer>
#  </alias>

#  <alias>
#   <family>monospace</family>
#   <prefer>
#     <family>Noto Mono</family>
#     <family>Noto Color Emoji</family>
#     <family>Noto Emoji</family>
#     <family>DejaVu Sans Mono</family>
#    </prefer>
#  </alias>
# </fontconfig>

# " > /etc/fonts/local.conf

# # 3 - update font cache via fc-cache
# fc-cache

# echo "Noto Emoji Font installed! You may need to restart applications like chrome. If chrome displays no symbols or no letters, your default font contains emojis."

# echo "consider inconsolata regular"

