ZSH=$HOME/.oh-my-zsh
ZSH_THEME="agnoster"
SOLARIZED_THEME="dark"
DEFAULT_USER="$USER"
ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_AUTOCONNECT=true
ZSH_TMUX_AUTOQUIT=true
ZSH_CUSTOM=$HOME/.oh-my-zsh-custom
COMPLETION_WAITING_DOTS="true"
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
plugins=(git rust ripgrep macos vi-mode fancy-ctrl-z tmux z zsh-syntax-highlighting H-S-MW zsh-autosuggestions virtualenv)
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=4'
source $ZSH/oh-my-zsh.sh

setopt noclobber

export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1

export SKIM_DEFAULT_COMMAND="rg --files"

# Makes managing cruft easier.
alias fedora_clear_leaves=$'sudo dnf --setopt=clean_requirements_on_remove=false erase $(awk -v FS=\'\t\' -v OFS=\'\t\' \'NR==FNR {wf[$1];next}{if (!($1 in wf) && $1 !~ /-fonts?-?/) {print $2,$3,$4/1024**2}}\' $HOME/.dotfiles/fedora_worldfile <(rpm -q --queryformat "%{NAME}\t%{NAME}-%{VERSION}-%{RELEASE}.%{ARCH}\t%{SUMMARY}\t%{SIZE}\n" $(dnf leaves) | sort -t $\'\t\' -k 4nr) | column -ts $\'\t\' | peco | awk \'{print $1}\')'
alias fedora_add2worldfile='comm -23 <(rpm -q --queryformat "%{NAME}\n" $(for pkgname in `dnf leaves`; [[ ! $pkgname =~ -fonts- ]] && echo $pkgname;) | sort | uniq) <(sort $HOME/.dotfiles/fedora_worldfile) | peco >> $HOME/.dotfiles/fedora_worldfile'
alias fedora_install_from_worldfile='sudo dnf install $(comm -23 <(sort $HOME/.dotfiles/fedora_worldfile) <(rpm -qa --queryformat "%{NAME}\n" | sort | uniq) | peco)'

rg2vim() {
	vim -c "$(
	FL=0
	while IFS=: read -r fn ln line; do
		if [ "$FL" -eq "0" ]; then
			printf "e %q|" "$fn"
			FL=1
		else
			printf "tabnew %q|" "$fn"
		fi
		printf ":%d|" "$ln"
	done < <(rg -n "$1" | peco --select-1)
	)"
}

sk2vim() {
	cmds="$(
        FL=0
        while IFS=: read -r fn ln line; do
            if [ "$FL" -eq "0" ]; then
                printf "e %q|" "$fn"
                FL=1
            else
                printf "tabnew %q|" "$fn"
            fi
            printf ":%d|" "$ln"
        done < <(rg -n "$1" | sk --preview 'bat --color=always --style=numbers --line-range={2}:500 {1}' -d ':' --preview-window=down --layout=reverse --height 40% --select-1 --exit-0 --no-sort --multi)
	)"
    if [ "$cmds" ]; then
        vim -c $cmds
    fi
}

alias please='sudo $(fc -ln -1)'

boxxed() {
    docker build -t fedora_boxxed:latest - < $HOME/.dotfiles/fedora_boxxed && \
    docker run -w /root -e TERM=$TERM -v $HOME/.dotfiles:/root/.dotfiles:ro --rm=true -it fedora_boxxed
}

export SCCACHE_CACHE_SIZE="10G"
