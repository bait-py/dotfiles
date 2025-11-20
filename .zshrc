# Activar promptinit y Pure
fpath+=($HOME/.zsh/pure)
autoload -U promptinit; promptinit
prompt pure

# Autocompletado
autoload -U compinit; compinit
zstyle ':completion:*' menu select

# Opcional: alias, exports, etc.
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias ll='ls -la --color=auto'
alias lt='ls --tree'

alias serve='npx http-server . -c-1'

### PYENV
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

. "$HOME/.local/bin/env"
source $HOME/.local/bin/env

# NVIM path
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

. "$HOME/.atuin/bin/env"

eval "$(atuin init zsh)"
