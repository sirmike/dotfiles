source $HOME/scripts/zsh-git-prompt/zshrc.sh

PROMPT='%n@%m:%~$(git_super_status) %# '
CDPATH=".:/Users/michalw/git"

fpath=(/usr/local/share/zsh-completions $fpath)

autoload -U compinit
compinit

source /usr/local/opt/chruby/share/chruby/chruby.sh
source /usr/local/opt/chruby/share/chruby/auto.sh

PATH=$HOME/scripts:$PATH

source $HOME/.zaliases

to_json() {
  underscore print --color -
}

to_xml() {
  xmllint --format - | highlight --out-format=xterm256 --syntax=xml
}

EDITOR='vim'
VISUAL='mvim -f'

bindkey "\e[3~" delete-char

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# disable flow control to allow vim using ctrl+s
stty -ixon

# set history size
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.history
