#
# ~/.bashrc is sourced when running interactive shell
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# If .env file exist then load it
[[ -f ~/.env ]] && . ~/.env

### Required by status bar script ###
export DWM_PATH='/home/vts/git'

### PROMPT
# This is commented out if using starship prompt
# PS1='[\u@\h \W]\$ '

### PATH
if [ -d "$HOME/.local/bin" ] ;
  then PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$DWM_PATH/black-dwm-6.3/scripts" ] ;
  then PATH="$DWM_PATH/black-dwm-6.3/scripts:$PATH"
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
alias e='emacs -nw'

# Changing "ls" to "exa"
alias ll='exa -agl --color=always --group-directories-first' # my preferred listing
alias la='exa -a --color=always --group-directories-first'  # all files and dirs
alias ls='exa -lg --color=always --group-directories-first'  # long format
alias lt='exa -aT --color=always --group-directories-first' # tree listing
alias l.='exa -a | egrep "^\."'

# pacman and yay
alias pacsyu='sudo pacman -Syyu'                 # update only standard pkgs
alias yaysua='yay -Sua --noconfirm'              # update only AUR pkgs (yay)
alias yaysyu='yay -Syu --noconfirm'              # update standard pkgs and AUR pkgs (yay)
alias parsua='paru -Sua --noconfirm'             # update only AUR pkgs (paru)
alias parsyu='paru -Syu --noconfirm'             # update standard pkgs and AUR pkgs (paru)
alias unlock='sudo rm /var/lib/pacman/db.lck'    # remove pacman lock
alias cleanup='sudo pacman -Rns (pacman -Qtdq)'  # remove orphaned packages

# Colorize grep output (good for log files)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# confirm before overwriting something
alias cp="cp -i"
alias mv='mv -i'
alias rm='rm -i'

# adding flags
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias lynx='lynx -cfg=~/.lynx/lynx.cfg -lss=~/.lynx/lynx.lss -vikeys'
alias vifm='./.config/vifm/scripts/vifmrun'
alias ncmpcpp='ncmpcpp ncmpcpp_directory=$HOME/.config/ncmpcpp/'
alias mocp='mocp -M "$XDG_CONFIG_HOME"/moc -O MOCDir="$XDG_CONFIG_HOME"/moc'

# ps
alias psa="ps auxf"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"
alias psmem='ps auxf | sort -nr -k 4'
alias pscpu='ps auxf | sort -nr -k 3'

# Merge Xresources
alias merge='xrdb -merge ~/.Xresources'

# Replace cal with calcurse and sync calcurse before and afer changes
# with remote caldav server
alias cal="calcurse-caldav; calcurse; calcurse-caldav"

# Backup a file
bak () {
    file_name="$1"
    cp "$file_name" "$1.bak"
}


### Required by lxapprence ###
export QT_QPA_PLATFORMTHEME="qt5ct"  

### SETTING THE STARSHIP PROMPT ###
eval "$(starship init bash)"

### RANDOM COLOR SCRIPT ###
# Color script from https://gitlab.com/dwt1/shell-color-scripts.git ###
colorscript random

### Specifie ssh key to git ###
### This is ingnored because ssh keys are specified in ~/.ssh/config
# export GIT_SSH_COMMAND='ssh -i ~/.ssh/BlackcatRs'

### Default application to use
export EDITOR="emacs"
export TERMINAL="alacritty"
export BROWSER="firefox"

# run automatically "startx" after login
if [[ "$(tty)" = "/dev/tty1" ]]; then
    pgrep startx || startx
fi

# Allow SSH client to access use gpg-agent instead ssh-agent. This is
# done by changing the value of the SSH_AUTH_SOCK environment variable.
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

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



