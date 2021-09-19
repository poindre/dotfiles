export PATH=XDG_CONFIG_HOME=$HOME/.config:$PATH
export DOCKER_CONTENT_TRUST=0

# ------ #
# Anyenv #
# ------ #
export PATH=$HOME/.anyenv/bin:$PATH

# ---------------- #
# Settings for fzf #
# ---------------- #
export PATH="$PATH:$HOME/.fzf/bin"
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git" --glob "!node_modules" --glob "!vendor"'
export FZF_DEFAULT_OPTS='--height 30% --border'
