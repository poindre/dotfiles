# alias vim='nvim $(fzf)'
alias vim='nvim'
alias sed='gsed'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'

alias node="nocorrect node"
alias npm="nocorrect npm"
alias composer="nocorrect composer"

# C で標準出力をクリップボードにコピーする
alias -g C='| pbcopy'

# Git
alias g='git'
alias gpl='git pull'
alias gps='git push'
alias gst='git status'
alias gad='git add -A'
alias gdf='git diff --word-diff'

# SSH
# prd で終わる場合は背景を赤色にする
# stg で終わる場合は背景を緑色にする
# dev で終わる場合は背景を青色にする
function ssh_color() {
 case $1 in
   *-prd ) echo -e "\033]1337;SetProfile=bg_red\a" ;;
   *-stg ) echo -e "\033]1337;SetProfile=bg_green\a" ;;
   *-dev ) echo -e "\033]1337;SetProfile=bg_blue\a" ;;
   *) echo -e "\033]1337;SetProfile=Default\a" ;;
 esac
  ssh $@
  echo -e "\033]1337;SetProfile=Default\a"
}

alias ssh='ssh_color'
