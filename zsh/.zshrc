# .: ~ zsh/.zshrc file ~ :.
# by aru

if [[ -r "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[[ ! -f "$XDG_CONFIG_HOME/zsh/p10k.zsh" ]] || source "$XDG_CONFIG_HOME/zsh/p10k.zsh"

plugins=(
    git
    autojump
    vi-mode
    zsh-syntax-highlighting
    zsh-autosuggestions
    zsh-completions
)

autoload -U compinit && compinit
autoload -U zmv

setopt HIST_IGNORE_SPACE share_history
unsetopt prompt_cr prompt_sp

source $ZSH/oh-my-zsh.sh

alias l='/bin/ls --color=auto --group-directories-first -lhAH'
alias pacman='pacman --color always'
alias update_grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias update_pip='sudo pip-update.py'
alias fuck='sudo $(fc -ln -1)'
alias wget="wget --hsts-file $XDG_CACHE_HOME/wget/hosts"

# EOF
