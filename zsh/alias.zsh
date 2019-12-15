alias c='clear'
alias l='ls -lah'
alias mv='mv -i'
alias cp='cp -i'

# vim
alias v='vim'
alias vi='vim'

# dotfiles
alias dot='cd ~/dotfiles'
alias tmuxs='tmux source-file ~/.tmux.conf'
alias zshrc='vim ~/.zshrc'

alias memory='top -o mem'
alias cpu='top -o cpu'

# interactive cd
# requires fzf
fd() {
  local dir
  dir=$(find ${1:-.} -type d 2> /dev/null | fzf --reverse +m) && cd "$dir"
  zle reset-prompt
}
zle -N fd
bindkey '^f' fd

# requires tree
alias tree='tree -a -I "\.DS_Store|\.git|\.svn|node_modules|vendor|tmp|volumes" -N -A -C'

# requires rmtrash
alias rm='rmtrash'

# git
alias ga='git add'
alias gap='git add -p'
alias gc='git commit -v -m'
alias gca='git commit --amend'
alias gst='git status'
alias gd='git diff'
alias gf='git fetch'
alias current_branch='git rev-parse --abbrev-ref HEAD'
alias gcob='git checkout -b'
alias gpull='git pull origin `git rev-parse --abbrev-ref HEAD`'
alias gpush='git push origin `git rev-parse --abbrev-ref HEAD`'
alias gdmerged='git branch --merged master | grep -vE "^\*|master|develop|staging$" | xargs -I % git branch -d %'

# interactive cd to ghq repository
# requires ghq, fzf
function move_to_repository() {
  cd $(ghq list -p --vcs=git | fzf --reverse)
  zle reset-prompt
}
zle -N move_to_repository
bindkey '^g' move_to_repository

# requires hub
alias github="hub browse"
pr() {
  branch_name=$1;\
  template_path=$(git rev-parse --show-toplevel)/.github/PULL_REQUEST_TEMPLATE.md;\ 
  if [ -z ${branch_name} ]; then\
      branch_name='master';\
  fi;\
  hub browse -- compare/${branch_name}'...'$(git symbolic-ref --short HEAD)'?'expand=1'&'body=$(cat ${template_path} | perl -pe 'encode_utf8' | perl -pe 's/([^ 0-9a-zA-Z])/\"%\".uc(unpack(\"H2\",$1))/eg' | perl -pe 's/ /+/g');\
}

alias dc='docker-compose'
alias kc='kubectl'


OS=`uname`
case OS in
  "Darwin" ) # requires gnu-sed
    his() {
      print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | gsed -r 's/ *[0-9]*\*? *//' | gsed -r 's/\\/\\\\/g')
    }

    gco() {
      local branches branch
      branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)") &&
      branch=$(echo "$branches" |
               fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
      git checkout $(echo "$branch" | gsed "s/.* //" | gsed "s#remotes/[^/]*/##")
    }

    alias xcode='open -a xcode .'

    function f() {
      if [ -z "$1" ]; then
        open .
      else
        open "$@"
      fi
    }
  ;;

  "Linux" )
    his() {
      print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -r 's/ *[0-9]*\*? *//' | sed -r 's/\\/\\\\/g')
    }

    gco() {
      local branches branch
      branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)") &&
      branch=$(echo "$branches" |
               fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
      git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
    }
  ;;
esac