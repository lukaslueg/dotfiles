#!/bin/bash
set -e

# install git manually, dotfiles cloned to $HOME/.dotfiles

VIM_DIR=$HOME/.vim
VIMPAGER_DIR=$HOME/.vimpager
OHMYZSH_DIR=$HOME/.oh-my-zsh
PECO_BIN=/usr/local/bin/peco
ROXTERM_COLOR_DIR=$HOME/.config/roxterm.sourceforge.net/Colours

if [ ! -d $VIM_DIR ]; then
    mkdir $VIM_DIR
    ln -s $HOME/.dotfiles/vim_modules $VIM_DIR/bundle
    git -C $HOME/.dotfiles/vim_modules submodule update --init --recursive
    mkdir $HOME/.vim/autoload
    sudo dnf install -y wget
    wget -O$HOME/.vim/autoload/pathogen.vim https://raw.github.com/tpope/vim-pathogen/HEAD/autoload/pathogen.vim
fi

# Symlink all the dotfiles
for f in gitconfig gitignore tmux.conf vimpagerrc vimrc zshrc; do
    if [ ! -e $HOME/.$f ]; then
        ln -s $HOME/.dotfiles/$f $HOME/.$f
    fi
done
if [ ! -d $ROXTERM_COLOR_DIR ]; then
    mkdir -p $ROXTERM_COLOR_DIR
    ln -s $HOME/.dotfiles/config_roxterm.sourceforge.net_Colours_solarized-dark $ROXTERM_COLOR_DIR/solarized-dark
    ln -s $HOME/.dotfiles/config_roxterm.sourceforge.net_Colours_solarized-light $ROXTERM_COLOR_DIR/solarized-light
fi

sudo dnf install -y wget tar zsh tmux tmux-powerline vim vim-plugin-powerline util-linux-user python-libs

# Install vimpager
if [ ! -d $VIMPAGER_DIR ]; then
    git clone https://github.com/rkitover/vimpager $VIMPAGER_DIR
fi

# Install oh-my-zsh
if [ ! -d $OHMYZSH_DIR ]; then
    git clone https://github.com/robbyrussell/oh-my-zsh $OHMYZSH_DIR
fi

# Install peco
if [ ! -x $PECO_BIN ]; then
    wget -qO- https://github.com/peco/peco/releases/download/v0.4.5/peco_linux_amd64.tar.gz | tar xz --strip-components=1 peco_linux_amd64/peco
    sudo install -g root -o root peco $PECO_BIN
    rm peco
fi

# Change shell to ZSH
chsh -s /bin/zsh

# Select and install additional stuff from the worldfile
sudo dnf install $(comm -23 <(sort $HOME/.dotfiles/fedora_worldfile) <(rpm -qa --queryformat "%{NAME}\n" | sort -u) | peco)
