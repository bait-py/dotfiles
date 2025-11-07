# Activar promptinit y Pure
fpath+=($HOME/.zsh/pure)
autoload -U promptinit; promptinit
prompt pure

# Autocompletado
autoload -U compinit; compinit
zstyle ':completion:*' menu select

# Opcional: alias, exports, etc.
alias ll='ls -la --color=auto'
alias ls='ls --color=auto'
alias serve='npx http-server . -c-1'

### PYENV
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

. "$HOME/.local/bin/env"
source $HOME/.local/bin/env
