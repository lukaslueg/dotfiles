ZSH=$HOME/.oh-my-zsh
ZSH_THEME="agnoster"
DEFAULT_USER="$USER"
ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_AUTOCONNECT=true
ZSH_TMUX_AUTOQUIT=true
ZSH_CUSTOM=$HOME/.oh-my-zsh-custom
COMPLETION_WAITING_DOTS="true"
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
plugins=(git python colored-man mercurial osx vi-mode fancy-ctrl-z tmux z zsh-syntax-highlighting history-search-multi-word zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

GOPATH=~/dev/gocode
GOROOT=/usr/lib/golang
PATH="$PATH:$GOPATH/bin"

setopt noclobber

# Makes managing cruft easier.
alias fedora_clear_leaves=$'sudo dnf --setopt=clean_requirements_on_remove=false erase $(awk -v FS=\'\t\' -v OFS=\'\t\' \'NR==FNR {wf[$1];next}{if (!($1 in wf) && $1 !~ /-fonts?-?/) {print $2,$3,$4/1024**2}}\' $HOME/.dotfiles/fedora_worldfile <(rpm -q --queryformat "%{NAME}\t%{NAME}-%{VERSION}-%{RELEASE}.%{ARCH}\t%{SUMMARY}\t%{SIZE}\n" $(dnf leaves) | sort -t $\'\t\' -k 4nr) | column -ts $\'\t\' | peco | awk \'{print $1}\')'
alias fedora_add2worldfile='comm -23 <(rpm -q --queryformat "%{NAME}\n" $(for pkgname in `dnf leaves`; [[ ! $pkgname =~ -fonts- ]] && echo $pkgname;) | sort | uniq) <(sort $HOME/.dotfiles/fedora_worldfile) | peco >> $HOME/.dotfiles/fedora_worldfile'
alias fedora_install_from_worldfile='sudo dnf install $(comm -23 <(sort $HOME/.dotfiles/fedora_worldfile) <(rpm -qa --queryformat "%{NAME}\n" | sort | uniq) | peco)'

VIMPAGER="$HOME/.vimpager/vimpager"
if [[ -x $VIMPAGER ]]; then
    PAGER=$VIMPAGER
    alias less=$PAGER
    alias zless=$PAGER
fi
