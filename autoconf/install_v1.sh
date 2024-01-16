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
    # TODO execute stow command
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

text_editor() {
    $PACKAGE_MANAGER emacs aspell aspell-en aspell-fr
    # TODO The SMTP password will be retrieved from the file defined in the "auth-sources" variable

}

pdf_viewer(){
    $PACKAGE_MANAGER zathura poppler zathura-pdf-poppler
}

file_explorer() {
    $PACKAGE_MANAGER ranger fzf ueberzug imagemagick
    # TODO run shortcuts.sh script 
}

aur_helper() {
    DST="$HOME/git/yay"
    [ ! -d $DST ] && mkdir -p $DST
    git clone https://aur.archlinux.org/yay.git $DST
    cd $DST
    /usr/bin/makepkg -si
}

offline_mail() {
    $PACKAGE_MANAGER isync mu && /usr/bin/mbsync -a
    # TODO Override mbsync service
    # [Service]
    # ExecStart=
    # ExecStart=/usr/bin/mbsync -V -c /path/to/config/file -a
    # Environment="PASSWORD_STORE_DIR=/path/to/password/pass"
}

mail_notif() {
    $PACKAGE_MANAGER goimapnotify
}

initialCheck
#aur_helper

checkOS
offline_mail
