export XDG_CONFIG_HOME=$HOME/.config
export DOCKER_CONTENT_TRUST=0

# ---- #
# asdf #
# ---- #
export PATH="${~/.asdf}/shims:$PATH"

# ---------------- #
# Settings for fzf #
# ---------------- #
export PATH="$PATH:$HOME/.fzf/bin"
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git" --glob "!node_modules" --glob "!vendor"'
export FZF_DEFAULT_OPTS='--height 30% --border'

# ----------------------- #
# Setting fot Docker-Sync #
# ----------------------- #
if which ruby >/dev/null && which gem >/dev/null; then
  PATH="$(ruby -r rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi
