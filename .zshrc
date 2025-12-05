eval "$(starship init zsh)"

# Autocompletado
autoload -U compinit; compinit
zstyle ':completion:*' menu select
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/plugins/zsh-autopair/zsh-autopair.plugin.zsh
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# --- Alias y Exports ---
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias ll='ls -la --color=auto'
alias lt='ls --tree'
alias serve='npx http-server . -c-1'

# --- Carga de Archivos ---
# Si estos archivos son scripts que exportan variables, usa 'source' o '.' una sola vez.
. "$HOME/.local/bin/env"


# --- OPTIMIZACIÓN DE PYENV (Lazy Loading) ---
# Usamos 'pyenv init --no-rehash' para acelerar la inicialización.
# Y SOLO cargamos el rehash cuando realmente se necesita.

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"

# Esto carga PYENV, pero SIN escanear todos los entornos (la parte lenta)
eval "$(pyenv init - zsh --no-rehash)"

# Recomendado: Usa un plugin como 'zsh-defer' si necesitas cargar Pyenv solo en ciertos directorios.
# Si necesitas rehash automático, puedes instalar 'pyenv-virtualenv' o 'pyenv-deactivate'.

# --- ATUIN ---
. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh)"

# POKEGET
export PATH="$HOME/.local/bin:$PATH"
pokeget random --hide-name