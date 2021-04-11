# .: ~ fish/config.fish file ~ :.
# by aru

set fish_greeting
set TERM "xterm-256color"

set EDITOR "kak"
set VISUAL "emacs"

set PYLINTHOME         "$XDG_CONFIG_HOME/pylint.d"
set WAKATIME_HOME      "$XDG_CONFIG_HOME/wakatime"
set GNUPGHOME          "$XDG_CONFIG_HOME/gnupg"
set PYTHONSTARTUP      "$XDG_CONFIG_HOME/python/pyrc"
set WGETRC             "$XDG_CONFIG_HOME/wget/wgetrc"
set GOPATH             "$HOME/.local/go"
set GHCUP_USE_XDG_DIRS "TRUE"
set NODE_REPL_HISTORY  "$XDG_CACHE_HOME/npm/repl_history"

set PATH $PATH $GOPATH/bin $XDG_CONFIG_HOME/emacs/bin

set -x BAT_THEME "gruvbox-dark"

set -x MANPAGER "sh -c 'col -xb | bat -l man'"

function fish_user_key_bindings
         fish_vi_key_bindings
end

theme_gruvbox dark hard

alias l='/bin/ls --color=auto --group-directories-first -lhAH'
alias pacman='pacman --color always'
alias update_grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias update_pip='sudo pip-update.py'
alias fuck='sudo (fc -ln -1)'
alias wget="wget --hsts-file $XDG_CACHE_HOME/wget/hosts"
