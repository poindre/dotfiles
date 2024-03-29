set termguicolors

# ---------------------- #
# powerlevel10k Settings #
# ---------------------- #
if [[ -r "${DOTDIR}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${DOTDIR}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --------------- #
# ZSHELL Settings #
# --------------- #
# 補完
# 補完機能を有効化
autoload -U compinit
compinit

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..

# cdコマンド補完の見出し文
zstyle ':completion:*:descriptions' format '%BCompleting%b %U%d%u'

# -------------- #
# ZSHELL Options #
# -------------- #
# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# beep を無効にする
setopt no_beep

# フローコントロールを無効にする
setopt no_flow_control

# Ctrl+Dでzshを終了しない
setopt ignore_eof

# '#' 以降をコメントとして扱う
setopt interactive_comments

# ディレクトリ名だけでcdする
setopt auto_cd

# cd したら自動的にpushdする
DIRSTACKSIZE=100
setopt AUTO_PUSHD

# 重複したディレクトリを追加しない
setopt pushd_ignore_dups

# 同時に起動したzshの間でヒストリを共有する
setopt share_history

# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups

# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space

# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks

# 高機能なワイルドカード展開を使用する
setopt extended_glob

# --------------- #
# ZSHELL KeyBinds #
# --------------- #
# ^R で履歴検索をするときに * でワイルドカードを使用出来るようにする
bindkey '^R' history-incremental-pattern-search-backward

# ------ #
# prezto #
# ------ #
source "${ZDOTDIR}/.zprezto/init.zsh"

eval "$(anyenv init -)"

# To customize prompt, run `p10k configure` or edit ~/.zsh/.p10k.zsh.
[[ ! -f ${ZDOTDIR}/.p10k.zsh ]] || source ${ZDOTDIR}/.p10k.zsh

# --------- #
# Cargo env #
# --------- #
source "${HOME}/.cargo/env"

# ----------- #
# coc Setting #
# ----------- #
# add @ to iskeyword option.
# autocmd FileType scss setl iskeyword+=@-@
