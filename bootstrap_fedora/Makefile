.DEFAULT_GOAL := all
.PHONY: additional_packages

DOTFILES := gitconfig gitignore tmux.conf vimpagerrc vimrc zshrc
PECO_VERSION := 0.4.5
H := $(HOME)
DOTD := $H/.dotfiles
HBIN := $H/.local/bin
VIMD := $H/.vim
ROXTERMD=$H/.config/roxterm.sourceforge.net/Colours

$(ROXTERMD)/solarized-dark $(ROXTERMD)/solarized-light:
	mkdir -p $(ROXTERMD)
	ln -s $(DOTD)/config_roxterm_sourceforge.net_Colours_$(@F) $(ROXTERMD)/$(@F)

$(VIMD)/autoload/pathogen.vim: | /usr/bin/wget
	mkdir -p $(@D)
	wget -qO$@ https://raw.github.com/tpope/vim-pathogen/HEAD/autoload/pathogen.vim

$(VIMD)/bundle:
	mkdir -p $(VIMD)
	ln -s $(DOTD)/vim_modules $@
	git -C $@ submodule update --quiet --init --recursive

/usr/bin/wget:
	sudo dnf --quiet install -y wget

$H/.%: $(DOTD)/%
	ln -s $< $@

$H/.oh-my-zsh:
	git clone --quiet https://github.com/robbyrussell/oh-my-zsh $@

$H/.vimpager:
	git clone --quiet https://github.com/rkitover/vimpager $@

$(HBIN)/peco: | /usr/bin/wget
	mkdir -p $(@D)
	wget -qO- https://github.com/peco/peco/releases/download/v$(PECO_VERSION)/peco_linux_amd64.tar.gz | tar xOz peco_linux_amd64/peco > $@
	chmod +x $@

additional_packages:
	sudo dnf --quiet install -y zsh tmux tmux-powerline vim vim-plugin-powerline util-linux-user python-libs powerline
	bash -c 'sudo dnf install $$(comm -23 <(sort $(DOTD)/fedora_worldfile) <(rpm -qa --queryformat "%{NAME}\n" | sort -u) | peco)'

all: $(VIMD)/autoload/pathogen.vim $(VIMD)/bundle $(addprefix $H/.,$(DOTFILES)) $H/.oh-my-zsh $H/.vimpager $(HBIN)/peco $(ROXTERMD)/solarized-dark $(ROXTERMD)/solarized-light
