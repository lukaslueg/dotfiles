SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := all

ifeq ($(shell uname -s),Darwin)
PECO_OS := darwin_amd64
else
PECO_OS := linux_amd64
endif

DOTFILES := gitconfig gitignore tmux.conf vimpagerrc vimrc zshrc
H := $(HOME)
DOTD := $H/.dotfiles
HBIN := $H/.local/bin
VIMD := $H/.vim
PATHOGEND := $H/.vim-pathogen
ROXTERMD := $H/.config/roxterm.sourceforge.net/Colours
OHMYZSHD := $H/.oh-my-zsh

ZSHPLUGINSD := $(addprefix $H/.oh-my-zsh-custom/plugins/, zsh-syntax-highlighting history-search-multi-word zsh-autosuggestions)
zsh-syntax-highlighting-gh := zsh-users
history-search-multi-word-gh := psprint
zsh-autosuggestions-gh := zsh-users
vimpager-gh := rkitover
oh-my-zsh-gh := robbyrussell
vim-pathogen-gh := tpope

VIMPLUGINSD := $(addprefix $(VIMD)/bundle/, delimitMate vim-gitgutter rust.vim syntastic ctrlp.vim tagbar vim-fugitive nerdtree vim-colors-solarized)
ctrlp.vim-gh := kien
vim-gitgutter-gh := airblade
rust.vim-gh := rust-lang
syntastic-gh := vim-syntastic
delimitMate-gh := Raimondi
tagbar-gh := majutsushi
vim-fugitive-gh := tpope
nerdtree-gh := scrooloose
vim-colors-solarized-gh := altercation

GITHUBTARGETS := $(OHMYZSHD) $(ZSHPLUGINSD) $H/.vimpager $(PATHOGEND) $(VIMPLUGINSD)

$(ROXTERMD) $(VIMD) $(HBIN):
	mkdir -p $@

$(ROXTERMD)/solarized-dark $(ROXTERMD)/solarized-light: | $(ROXTERMD)
	ln -s $(DOTD)/config_roxterm.sourceforge.net_Colours_$(@F) $(ROXTERMD)/$(@F)

/usr/bin/curl:
	sudo dnf --quiet install -y curl

$H/.%: $(DOTD)/%
	ln -s $< $@

$(VIMD)/autoload: | $(PATHOGEND) $(VIMD)
	ln -s $(PATHOGEND)/autoload $@

$(GITHUBTARGETS):
	git -C $@ pull --quiet && git -C $@ submodule update --quiet --recursive --remote --init ||  git clone --recursive --quiet https://github.com/$($(@F:.%=%)-gh)/$(@F:.%=%) $@

$(HBIN)/peco: | $(HBIN) /usr/bin/curl
	/usr/bin/curl -sL $$(curl -s https://api.github.com/repos/peco/peco/releases | grep browser_download | grep $(PECO_OS) | head -n1 | cut -d '"' -f4) | tar xOz peco_$(PECO_OS)/peco > $@
	chmod +x $@

.PHONY: additional_packages
additional_packages:
	sudo dnf --quiet install -y zsh tmux tmux-powerline vim vim-plugin-powerline util-linux-user python-libs powerline

.PHONY: oh-my-zsh dotfiles vim vimpager peco roxterm
oh-my-zsh: $(ZSHPLUGINSD) $(OHMYZSHD)
dotfiles: $(addprefix $H/.,$(DOTFILES))
vim: $(VIMD)/autoload $(VIMPLUGINSD)
vimpager: $H/.vimpager
peco: $(HBIN)/peco
roxterm: $(ROXTERMD)/solarized-dark $(ROXTERMD)/solarized-light

ifndef QUICKANDDIRTY
.PHONY: $(GITHUBTARGETS) $(HBIN)/peco
endif

.PHONY: all
all: vim dotfiles oh-my-zsh vimpager peco roxterm
