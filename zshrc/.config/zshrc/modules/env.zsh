# Language
export LANG=en_US.UTF-8

# Local binaries
export PATH="$HOME/.config/bin:$PATH"

# Source local-only config if present (gitignored)
[[ -f "${MODULES_DIR:-${0:A:h}}/env.local.zsh" ]] && source "${MODULES_DIR:-${0:A:h}}/env.local.zsh"

# Homebrew
export PATH=/opt/homebrew/bin:$PATH
export PATH="/usr/local/opt/curl/bin:$PATH"

# Editors
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='code'
fi

# NVM / Node
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/node@18/lib"
export CPPFLAGS="-I/opt/homebrew/opt/node@18/include"
export PATH="/opt/homebrew/opt/node@18/bin:$PATH"
export PATH="/usr/local/opt/node@10/bin:$PATH"

# Python / Pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
command -v pyenv >/dev/null && eval "$(pyenv init -)"

# Colors
export LS_OPTIONS='--color=auto'
export CLICOLOR='Yes'
export LSCOLORS="gxBxhxDxfxhxhxhxhxcxcx"

# Zoxide (replaces zsh-z)
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"

# FZF marks
[[ -f ~/.fzf-marks ]] || touch ~/.fzf-marks

# Manpath
# export MANPATH="/usr/local/man:$MANPATH"
