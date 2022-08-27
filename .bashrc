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
refus () {
    sudo dd bs=4M \
	 if=$1 \
	 of=$2 \
	 status=progress \
	 oflag=sync
}

# emacs
alias e='emacs -nw'

# Changing "ls" to "exa"
alias ll='exa -al --color=always --group-directories-first' # my preferred listing
alias la='exa -a --color=always --group-directories-first'  # all files and dirs
alias ls='exa -l --color=always --group-directories-first'  # long format
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

# Initiate vpn connexion
alias vpn='netExtender -u $USERNAME -d $DOMAIN $HOST:$PORT'
