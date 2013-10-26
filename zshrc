ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"

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

plugins=(git python colored-man mercurial osx vi-mode)

source $ZSH/oh-my-zsh.sh

bindkey '\e[A' history-beginning-search-backward
bindkey '\e[B' history-beginning-search-forward
bindkey "^R" history-incremental-search-backward

export GOPATH=~/dev/gocode
export PATH="$PATH:$GOPATH/bin"
