#! /usr/bin/env bash

PACKAGE_MANAGER=""
OS=""

checkOS() {
    if [[ -e /etc/arch-release ]]; then
	/usr/bin/pacman -Syy
	#PACKAGE_MANAGER="/usr/bin/pacman --noconfirm -S "
	PACKAGE_MANAGER="/usr/bin/pacman -S"
	OS="arch"
    else
	echo "[-] Your OS is not supported by $0 ..."
	exit 1
    fi
}

isRoot() {
    if [ "${EUID}" -ne 0 ]; then
	echo "You need to run this script as root"
	exit 1
    fi
}

initialCheck() {
    isRoot
    checkOS
    [[ -f ~/.bash_profile || -f ~/.bashrc ]] && rm ~/.bash_profile ~/.bashrc
}


microcode() {
    if grep --color -i 'model name' /proc/cpuinfo | grep -iqF 'Intel'; then
	echo "[+] Intel CPU is detected"
	echo "Downloading microcode for Intel CPU ..."
	$PACKAGE_MANAGER intel-ucode
    elif grep --color -i 'model name' /proc/cpuinfo | grep -iqF 'amd'; then
	echo "[+] AMD CPU is detected"
	echo "Downloading microcode for AMD CPU ..."
	$PACKAGE_MANAGER amd-ucode
    else
	echo "[-] Unable to detect the CPU"
	return 1
    fi
}

themes() {
    $PACKAGE_MANAGER picom gnome-themes-extra kvantum lxappearance qt5ct feh
}

app_launcher() {
    $PACKAGE_MANAGER rofi rofi-emoji rofi-calc rofi-pass papirus-icon-theme
}

password_manager() {
    $PACKAGE_MANAGER pass pass-otp xclip dmenu gpg
}

emacs() {
    $PACKAGE_MANAGER emacs aspell aspell-en aspell-fr
}

pdf_viewer(){
    $PACKAGE_MANAGER zathura poppler zathura-pdf-poppler
}

file_explorer() {
    $PACKAGE_MANAGER ranger fzf
}

aur_helper() {
    DST="$HOME/git/yay"
    [ ! -d $DST ] && mkdir -p $DST
    git clone https://aur.archlinux.org/yay.git $DST
    cd $DST
    /usr/bin/makepkg -si
}

# initialCheck
aur_helper

