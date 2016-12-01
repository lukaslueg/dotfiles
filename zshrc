ZSH=$HOME/.oh-my-zsh
ZSH_THEME="agnoster"

ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_AUTOCONNECT=true
ZSH_TMUX_AUTOQUIT=true


alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(git python colored-man mercurial osx vi-mode fancy-ctrl-z tmux)

source $ZSH/oh-my-zsh.sh

bindkey '\e[A' history-beginning-search-backward
bindkey '\e[B' history-beginning-search-forward
bindkey "^R" history-incremental-search-backward

export GOPATH=~/dev/gocode
export GOROOT=/usr/lib/golang
export PATH="$PATH:$GOPATH/bin"

_tmux_pane_words() {
  local expl
  local -a w
  if [[ -z "$TMUX_PANE" ]]; then
    _message "not running inside tmux!"
    return 1
  fi
  # capture current pane first
  w=( ${(u)=$(tmux capture-pane -J -p)} )
  for i in $(tmux list-panes -F '#P'); do
    # skip current pane (handled above)
    [[ "$TMUX_PANE" = "$i" ]] && continue
    w+=( ${(u)=$(tmux capture-pane -J -p -t $i)} )
  done
  _wanted values expl 'words from current tmux pane' compadd -a w
}

zle -C tmux-pane-words-prefix   complete-word _generic
zle -C tmux-pane-words-anywhere complete-word _generic
bindkey '^Xt' tmux-pane-words-prefix
bindkey '^X^X' tmux-pane-words-anywhere
zstyle ':completion:tmux-pane-words-(prefix|anywhere):*' completer _tmux_pane_words
zstyle ':completion:tmux-pane-words-(prefix|anywhere):*' ignore-line current
# display the (interactive) menu on first execution of the hotkey
zstyle ':completion:tmux-pane-words-(prefix|anywhere):*' menu yes select interactive
zstyle ':completion:tmux-pane-words-anywhere:*' matcher-list 'b:=* m:{A-Za-z}={a-zA-Z}'

setopt noclobber

# Makes managing cruft easier.
alias fedora_clear_leaves=$'sudo dnf --setopt=clean_requirements_on_remove=false erase $(awk -v FS=\'\t\' -v OFS=\'\t\' \'NR==FNR {wf[$1];next}{if (!($1 in wf) && $1 !~ /-fonts?-?/) {print $2,$3,$4/1024**2}}\' $HOME/.dotfiles/fedora_worldfile <(rpm -q --queryformat "%{NAME}\t%{NAME}-%{VERSION}-%{RELEASE}.%{ARCH}\t%{SUMMARY}\t%{SIZE}\n" $(dnf leaves) | sort -t $\'\t\' -k 4nr) | column -ts $\'\t\' | peco | awk \'{print $1}\')'
alias fedora_add2worldfile='comm -23 <(rpm -q --queryformat "%{NAME}\n" $(for pkgname in `dnf leaves`; [[ ! $pkgname =~ -fonts- ]] && echo $pkgname;) | sort | uniq) <(sort $HOME/.dotfiles/fedora_worldfile) | peco >> $HOME/.dotfiles/fedora_worldfile'
alias fedora_install_from_worldfile='sudo dnf install $(comm -23 <(sort $HOME/.dotfiles/fedora_worldfile) <(rpm -qa --queryformat "%{NAME}\n" | sort | uniq) | peco)'


if [[ "$OSTYPE" =~ "^darwin" ]]; then
    alias vim=/Applications/MacVim.app/Contents/MacOS/Vim
fi

VIMPAGER="$HOME/.vimpager/vimpager"
if [[ -x $VIMPAGER ]]; then
    export PAGER=$VIMPAGER
    alias less=$PAGER
    alias zless=$PAGER
fi

if [[ -f $HOME/.zshrc.local ]]; then
    source $HOME/.zshrc.local
fi
