SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := all

ifeq ($(shell uname -s),Darwin)
PECO_OS := darwin_amd64
else
PECO_OS := linux_amd64
endif

DOTFILES := gitconfig gitignore tmux.conf vimrc zshrc
H := $(HOME)
DOTD := $H/.dotfiles
HBIN := $H/.local/bin
VIMD := $H/.vim
PATHOGEND := $H/.vim-pathogen
OHMYZSHD := $H/.oh-my-zsh

tpm-gh := tmux-plugins

ZSHPLUGINSD := $(addprefix $H/.oh-my-zsh-custom/plugins/, zsh-syntax-highlighting zsh-autosuggestions H-S-MW)
zsh-syntax-highlighting-gh := zsh-users
history-search-multi-word-gh := psprint
zsh-autosuggestions-gh := zsh-users
oh-my-zsh-gh := robbyrussell
H-S-MW-gh := z-shell
vim-pathogen-gh := tpope

VIMPLUGINSD := $(addprefix $(VIMD)/bundle/, vim-airline vim-autoformat vim-gitgutter vim-easymotion rust.vim ctrlp.vim tagbar vim-fugitive nerdtree vim-markdown vim-tmux-focus-events nerdtree-git-plugin vim-startify gruvbox)
ctrlp.vim-gh := ctrlpvim
vim-gitgutter-gh := airblade
vim-easymotion-gh := easymotion
rust.vim-gh := rust-lang
tagbar-gh := majutsushi
vim-fugitive-gh := tpope
nerdtree-gh := scrooloose
vim-markdown-gh := gabrielelana
vim-tmux-focus-events-gh := tmux-plugins
vim-autoformat-gh := Chiel92
nerdtree-git-plugin-gh := Xuyuanp
vim-startify-gh := mhinz
gruvbox-gh := morhetz
ale := dense-analysis
vim-airline := vim-airline

GITHUBTARGETS := $(OHMYZSHD) $(ZSHPLUGINSD) $(PATHOGEND) $(VIMPLUGINSD) $H/.tmux/plugins/tpm

$(VIMD) $(HBIN) $H/.config/peco:
	mkdir -p $@

/usr/bin/curl:
	sudo dnf --quiet install -y curl

$H/.%: $(DOTD)/%
	ln -s $< $@

$H/.config/peco/config.json: $(DOTD)/peco_config.json | $H/.config/peco
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
	sudo dnf --quiet install -y zsh tmux tmux-powerline vim vim-plugin-powerline util-linux-user python-libs powerline gcc cmake tar ripgrep

.PHONY: oh-my-zsh dotfiles vim peco
oh-my-zsh: $(ZSHPLUGINSD) $(OHMYZSHD)
dotfiles: $(addprefix $H/.,$(DOTFILES)) $H/.config/peco/config.json
vim: $(VIMD)/autoload $(VIMPLUGINSD)
peco: $(HBIN)/peco
tpm: $H/.tmux/plugins/tpm

ifndef QUICKANDDIRTY
.PHONY: $(GITHUBTARGETS) $(HBIN)/peco
endif

.PHONY: all
all: vim dotfiles oh-my-zsh peco tpm
