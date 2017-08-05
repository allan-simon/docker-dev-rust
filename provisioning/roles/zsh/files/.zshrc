# to avoid ctrl-s freezing the terminal
# (which bug many students)
stty stop undef

#if available, use a better pager
if command -v most &>/dev/null;then
    export PAGER=most
fi


#umask 022;
bindkey -v
limit core 0

# Edit cmdline
autoload edit-command-line
zle -N edit-command-line
#autoload -U tetris
#zle -N tetris
#bindkey '^T' tetris
bindkey '^r' history-incremental-search-backward
bindkey '^x' edit-command-line
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '^?' backward-delete-char

bindkey j accept-line
bindkey g complete-word

###################
## Options Settings
###################
setopt correct
setopt auto_cd
setopt hist_ignore_dups
setopt auto_list
setopt append_history
setopt auto_param_keys
setopt auto_param_slash
setopt complete_aliases
setopt equals
setopt extended_glob
setopt hash_cmds
setopt hash_dirs
setopt mail_warning
setopt magic_equal_subst
setopt numericglobsort
setopt menu_complete
setopt prompt_subst

###################
## commands aliases
###################
alias ls="ls --color"
alias purge='(/bin/rm *~) 2>/dev/null; (/bin/rm .*~) 2>/dev/null'
alias mak='make'
alias news='slrn -n -f ~/.jnewsrc -i ~/.slrnrc'
alias vi='vim'
alias gv="gv -resize -center -antialias"
alias less='less -X -M'
alias make_muet="make 1>/dev/null"
alias ww="ns_who -ghst | grep"
alias mkdir='nocorrect mkdir' # no spelling correction on mkdir
alias ls='ls --color'
alias l='ls'
alias lh='ls -lh'
alias ll='ls -l'
alias la='ls -la'
alias lm='ls -la |more'
alias j=jobs
alias n='uname -n'
alias h=history
alias JJ="cd .."

#########
# In order to not to have to type rehash each
# time you install / update software
#########

function apt-get {
    /usr/bin/apt-get $@;
    rehash
}


###############
## my aliases
###############
# Un grep avec des couleurs :
export GREP_COLOR=31
alias grep='grep --color=auto'
plateforme=`uname -s`
###########################################
# Global aliases -- These do not have to be
# at the beginning of the command line.
###########################################
alias -g M='|more'
alias -g H='|head'
alias -g T='|tail'
alias -g tcopt="--types-check --hir-compute --hir-display" ## For Tiger

#########################
# Git stuff
########################
function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

function parse_git_status {
    noupdated=$(
        git status --porcelain 2> /dev/null |
        grep -E "^ (M|D)" |
        wc -l
    )
    nocommitted=$(
        git status --porcelain 2> /dev/null |
        grep -E "^(M|A|D|R|C)" |
        wc -l
    )

    if test $noupdated -gt 0 ; then echo -n "*"; fi
    if test $nocommitted -gt 0 ; then echo -n "+"; fi
}

#########
## Prompt
#########
#RPROMPT='%(?,%{[34m%}[%?]%{[0m%},%{[01m%}%{[31m%}Err %?%{[0m%}) %U%B%T%b%u'
autoload -U colors
colors
if [ "$USER" = "root" ] ; then
    user_color="red"
else
    user_color="blue"
fi
host_color="white"
path_color="yellow"
time_color="green"
reset_color="white"
user="%B%{$fg[$user_color]%}%n%{$fg[$time_color]%}[%T]%{$fg[$reset_color]%}"
time="%{$fg[$time_color]%}%T"
host="%B%U%{$fg[$host_color]%}$HOST%u"
cpath="%B%{$fg[$path_color]%}%20<...<%~"
end="%{$fg[$reset_color]%}"

#PROMPT="$user $end>> "
PROMPT=$'$user $(parse_git_branch)$(parse_git_status) $end>> '

# prompt on the right
RPROMPT="%(?,,%{[01m%}%{[31m%}Err %?%{[0m%})%B$end {$cpath$end}"

# Filename suffixes to ignore during completion
fignore=(.o .c~ .pro)

##################
## Terminal Stuffs
##################
if [ -f $HOME/.dircolorsrc ]; then
    eval `dircolors $HOME/.dircolorsrc`
fi

[[ -t 1 ]] && {
  chpwd() {
    case $TERM in
      sun-cmd) print -Pn "\e]l%n@%m %~\e\\" ;;
      *xterm*|rxvt|(k|E|dt)term) print -Pn "\e]0;%n@%m %~\a" ;;
    esac
  }
  chpwd
}

##############################
## Plugins autoload && bindkey
##############################
autoload mere zed zfinit

if [ $plateforme != "SunOS" ]; then
  zmodload zsh/complist
  bindkey m menu-select
  zmodload zsh/zpty
  autoload nslookup
  autoload -U zed
  autoload -U zmv
  autoload compinit
  compinit -u

  zstyle ':completion:*' format '%{[32m%}-=> %{[01m%}%d%{[0m%}'
  zstyle ':completion:*' auto-description 'specify: %d'
  zstyle ':completion:*' completer _complete _correct _approximate
  zstyle ':completion:*' group-name ''
  zstyle ':completion:*' insert-unambiguous true
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
  zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'l:|=* r:|=*' 'r:|[._-]=* r:|=*'
  zstyle ':completion:*' max-errors 2
  zstyle ':completion:*' menu select=5
  zstyle ':completion:*' original true
  zstyle ':completion:*' squeeze-slashes true
  zstyle ':completion:*' verbose true
  zstyle ':completion:*:processes' list-colors '=(#b)(?????)(#B)?????????????????????????????????([^ ]#/)#(#b)([^ /]#)*=00=01;31=01;33'
fi

###########################
## Personnal custom options
###########################
alias cd..="cd .."
alias getx="export DISPLAY=`echo $REMOTEHOST | cut -f1 -d' '`:0"

# historique
HISTFILE=~/.history
HISTSIZE=100000000
SAVEHIST=100000000
export HISTFILE SAVEHIST

##########################
# Docker specific things
##########################

# /etc/container_environment is created by the base image's init
# so that we have access to the docker environments variable
# from within the interactive shell
sudo cat /etc/container_environment.sh | grep -v 'export _=' | source /dev/stdin

export PATH=$PATH:/home/vagrant/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/bin/:/home/vagrant/.cargo/bin
export VISUAL="nvim"
export EDITOR="nvim"
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib:/usr/lib
export WORDCHARS="*?_-[]~=/&;!#$%^(){}<>"
# for racer
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"

cd /vagrant
