#
# ~/.bashrc is sourced when running interactive shell
#


# If not running interactively, don't do anything
[[ $- != *i* ]] && return


# If .env file exist then load it
[[ -f ~/.config/shell/env ]] && . ~/.config/shell/env


# XDG Base Directory specification which that where config files
# should be looked for by defining one or more base directories.
# https://wiki.archlinux.org/title/XDG_Base_Directory
[ ! -d "$HOME/.config" ] && /usr/bin/mkdir -p "$HOME/.config"
[ ! -d "$HOME/.local/state" ] && /usr/bin/mkdir -p "$HOME/.local/state"
[ ! -d "$HOME/.local/share" ] && /usr/bin/mkdir -p "$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_DATA_HOME="$HOME/.local/share"


# ~/ Clean-up:
export STARSHIP_CONFIG="$XDG_CONFIG_HOME"/starship/starship.toml  # Starship config 
export HISTFILE="$XDG_STATE_HOME"/bash/history # Bash history
export GTK_RC_FILES="$XDG_CONFIG_HOME"/gtk-1.0/gtkrc 
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export XINITRC="$XDG_CONFIG_HOME"/X11/xinitrc

# Load aliases and shortcuts if existent.
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"


# PATH
if [ -d "$HOME/.local/bin" ]; then
    /usr/bin/mkdir -p "$HOME/.local/bin"
    PATH="$HOME/.local/bin:$PATH"
fi


### ALIASES ###
# navigation
up () {
  local d=""
  local limit="$1"

  # Default to limit of 1
  if [ -z "$limit" ] || [ "$limit" -le 0 ]; then
    limit=1
  fi

  for ((i=1;i<=limit;i++)); do
    d="../$d"
  done

  # perform cd. Show error if cd fails
  if ! cd "$d"; then
    echo "Couldn't go up $limit dirs.";
  fi
}

# Create Bootable USB Drive Linux
rufus () {
    # Return error if no args is provide 
    if [ -z "$1" ] || [ -z "$2" ]; then
	echo Usage :
	echo rufus your_image.img /dev/sdXX
	return 1
    fi

    sudo dd bs=4M \
	 if=$1 \
	 of=$2 \
	 status=progress \
	 oflag=sync
}

# Start already installed virtualbox vm
vm () {
    vm_name="$1"
    vboxmanage startvm $vm_name --type headless
}

# emacs
if systemctl --user is-active --quiet emacs
then
    alias e='emacsclient -c -nw'
else
    alias e='emacs -nw'
fi


# Backup a file
bak () {
    file_name="$1"
    cp "$file_name" "$1.bak"
}

# Replace spaces in filename when downloading with wget
get () {
    # Return error if no args is provide 
    if [ -z "$1" ] || [ -z "$2" ]; then
	echo "Usage :"
	echo -e "\r get <URL> <Filename>"
	return 1
    fi

    filename=$(echo $2 | sed "s/ /_/g")
    wget $1 -O $filename
}

# Compress PDF files using ghostscript
reduce () {
    # Return error if no args is provide 
    if [ -z "$1" ] || [ -z "$2" ]; then
	echo Usage :
	echo "reduce <input_file.pdf> <compressed.pdf>"
	return 1
    fi

    /usr/bin/gs -sDEVICE=pdfwrite \
		-dCompatibilityLevel=1.4 \
		-dPDFSETTINGS=/prepress \
		-dNOPAUSE \
		-dQUIET \
		-dBATCH \
		-sOutputFile=$2 \
		$1
}

# Convert file format
md2org () {
    if [ -z "$1" ] || [ -z "$2" ]; then
	echo Usage :
	echo "md2org <input_file.md> <output_file.org>"
	return 1
    fi

    pandoc -f markdown -t org -o ${2} ${1};
}


# STARSHIP PROMPT
eval "$(starship init bash)"

# Random color script from
# https://gitlab.com/dwt1/shell-color-scripts.git
colorscript random


# Default programs

# Use default instance of Emacs running as daemon and "-c" creates a
# new frame for that instance. "-a" launches Emacs in normal mode
# instead of daemon mode if no daemon is disponible.
export EDITOR="emacsclient -c -a emacs"

export TERMINAL="alacritty"
export BROWSER="firefox"


### Required by lxapprence ###
export QT_QPA_PLATFORMTHEME="qt5ct"  


### Specifie ssh key to git ###
### This is ingnored because ssh keys are specified in ~/.ssh/config
# export GIT_SSH_COMMAND='ssh -i ~/.ssh/BlackcatRs'

# Inform SSH client to use gpg-agent instead ssh-agent. This is
# done by changing the value of the SSH_AUTH_SOCK environment variable.
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
#gpgconf --launch gpg-agent

# Inform gpg-agent about TTY on which prompt for GPG key passphrase
# and update gpg-agent to take effect all changes.
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null


# This replaces CapsLock with control and also replaces the Ctrl key on the right side with CapsLock just in case i ever need to use it.
# xmodmap ~/.Xmodmap
# The X keyboard extension, or XKB, defines the way keyboards codes are handled in X, and provides access to internal translation tables. It is the basic mechanism that allows using multiple keyboard layouts in X.
# Keyboard key mapping is done by setting XKB layout using rules in file /etc/X11/xorg.conf.d/90-custom-kbd.conf

# The bash_history file is used by recursive search when you press ctrl+r to search for commands entered in the past.
# ignore duplicate commands, ignore commands starting with a space in bash_history file
# ignoreboth is doing ignorespace:ignoredups and that along with erasedups.
export HISTCONTROL=ignoreboth:erasedups

# HISTSIZE is the number of lines or commands that are stored in
# memory in a history list while your bash session is running.

# HISTFILESIZE is the number of lines or commands (stored in memory
# when runngin a bash session) that will be stored in the history file
# (~/.bash_history) at the end of the bash session.
# Notice the distinction between file on disk and list in memory.
HISTSIZE=2000
HISTFILESIZE=2000


# shopt is a builtin command of the Bash shell that enables or
# disables options for the current shell session.  append commands
# that typed in the session that just finished to the history file
# instead of overwriting (good for multiple connections) if
# HISTFILESIZE value permits.
shopt -s histappend


# Start graphical server on user's current tty if not already running.
if [[ "$(tty)" = "/dev/tty1" ]]; then
    pgrep startx || startx 
fi
