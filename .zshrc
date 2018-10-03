# check speed for starting zsh
# $ time ( zsh -i -c exit )
# zmodload zsh/zprof && zprof

[[ -z "$TMUX" ]] && tmux

export LANG=ja_JP.UTF-8
export LC_CTYPE=ja_JP.UTF-8
export ZSH=~/.oh-my-zsh
export TERM=xterm-256color
export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/opt/mysql@5.6/bin:$PATH"
export PATH=/usr/local/opt/mysql@5.7/bin:$PATH
export NVM_DIR="$HOME/.nvm"
NODE_DEFAULT=versions/node/$(cat $NVM_DIR/alias/default)
export PATH=$NVM_DIR/$NODE_DEFAULT/bin:$PATH # this requires $ nvm alias default vX.Y.Z
MANPATH=$NVM_DIR/$NODE_DEFAULT/share/man:$MANPATH
NODE_PATH=$NVM_DIR/$NODE_DEFAULT/lib/node_modules
export NODE_PATH=${NODE_PATH:A}
export PGDATA=/usr/local/var/postgres
export PATH="/usr/local/bin/code:$PATH"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export GOPATH=$HOME/go
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH
export FZF_DEFAULT_COMMAND='ag --hidden -g ""'

# lazyload
function rbenv() {
  unset -f rbenv
  eval "$(rbenv init - --no-rehash)"
  rbenv "$@"
}
function goenv() {
  unset -f goenv
  eval "$(goenv init - --no-rehash)"
  goenv "$@"
}
function pyenv() {
  unset -f pyenv
  eval "$(pyenv init - --no-rehash)"
  pyenv "$@"
}
function swiftenv() {
  unset -f swiftenv
  eval "$(swiftenv init - --no-rehash)"
  swiftenv "$@"
}
function nvm() {
  unset -f nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm "$@"
}

# Settings for fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Settings for theme
ZSH_THEME="robbyrussell"
# ZSH_THEME="bullet-train"
# ZSH_THEME="spaceship" # too late
# ZSH_THEME="avit"

plugins=(osx zsh-syntax-highlighting zsh-256color zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

# Settings for pure theme # git branch is difficult to see
# ZSH_THEME=""
# autoload -U promptinit; promptinit
# prompt pure

# display
setopt print_exit_value

# no peep
setopt no_beep
setopt no_hist_beep
setopt no_list_beep

# warning before delete
setopt rm_star_wait

# autocomplete
setopt auto_list
setopt auto_menu

# ctags
# disable no matches found error
setopt nonomatch

## alias ##
alias v='vim'
alias vi='vim'
alias tmuxs='tmux source-file ~/.tmux.conf'
alias ll='ls -la'
alias c='clear'
alias cat='ccat'
alias tree='tree -a -I "\.DS_Store|\.git|\.svn|node_modules|vendor" -N -A -C'
alias ql='qlmanage -p "$@" >& /dev/null'
alias xcode='open -a xcode .'
alias myst='sudo mysql.server start'
alias defaultlocalserver='cd /Library/WebServer/Documents/'
alias localserver='cd ~/projects/local/'
alias apacheconfig='sudo vim /private/etc/apache2/httpd.conf'
alias apachelog='tail -n 100 /private/var/log/apache2/error_log'
alias his='cat ~/.zsh_history'
# aliases for git
alias ga='git add'
alias gap='git add -p'
alias gc='git commit -v -m'
alias gca='git commit --amend'
alias gst='git status'
alias gd='git diff'
alias current_branch='git rev-parse --abbrev-ref HEAD'
alias gco='git checkout `git branch -a | peco | sed -e "s/\* //g" | awk "{print \$1}"`'
alias gpull='git pull origin `git rev-parse --abbrev-ref HEAD`'
alias gf='git fetch'
alias gpush='git push origin `git rev-parse --abbrev-ref HEAD`'
alias gdmerged='git branch --merged master | grep -vE "^\*|master|develop|staging$" | xargs -I % git branch -d %'
alias github="hub browse"
function pr() {
  branch_name=$1;\
  template_path=$(git rev-parse --show-toplevel)/PULL_REQUEST_TEMPLATE.md;\ 
  if [ -z ${branch_name} ]; then\
      branch_name='master';\
  fi;\
  hub browse -- compare/${branch_name}'...'$(git symbolic-ref --short HEAD)'?'expand=1'&'body=$(cat ${template_path} | perl -pe 'encode_utf8' | perl -pe 's/([^ 0-9a-zA-Z])/\"%\".uc(unpack(\"H2\",$1))/eg' | perl -pe 's/ /+/g');\
}
# aliases for rails
alias rs='bundle exec rails s'
alias rc='bundle exec rails c'
alias rcs='bundle exec rails c -s'
function f() {
  if [ -z "$1" ]; then
    open .
  else
    open "$@"
  fi
}
# translatin
alias en='trans ja:en "$@"'
alias ja='trans en:ja "$@"'

# history
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
HISTTIMEFORMAT='%Y-%m-%d T%T%z '
setopt extended_history
setopt hist_no_store
setopt hist_expand
setopt inc_append_history
setopt hist_save_no_dups
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_all_dups

# Settings for gcp
# The next line updates PATH for the Google Cloud SDK.
if [ -f '~/google-cloud-sdk/path.zsh.inc' ]; then source '~/google-cloud-sdk/path.zsh.inc'; fi
# The next line enables shell command completion for gcloud.
if [ -f '~/google-cloud-sdk/completion.zsh.inc' ]; then source '~/google-cloud-sdk/completion.zsh.inc'; fi

# check speed for starting zsh
# if (which zprof > /dev/null) ;then
#   zprof | less
# fi

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
