# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/.local/bin:$HOME/bin
export PATH
export PS1="\[\e[31;1m\]\u\[\e[0m\]@\[\e[34;1m\]\w> \[\e[0m\]"
