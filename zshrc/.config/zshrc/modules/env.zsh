# Language
export LANG=en_US.UTF-8

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

# Java
export JAVA_HOME=/apollo/env/JavaSE8/jdk1.8
export PATH=$JAVA_HOME/bin:$PATH

# Python / Pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Other Tools
export PATH=$HOME/.toolbox/bin:$PATH
export PATH=$PATH:$HOME/.odin-tools/env/OdinRetrievalScript-1.0/runtime/bin
export PATH=/Applications/Fortify/Fortify_SCA_and_Apps_20.2.0/bin/:$PATH

# Colors
export LS_OPTIONS='--color=auto'
export CLICOLOR='Yes'
export LSCOLORS="gxBxhxDxfxhxhxhxhxcxcx"

# Manpath
# export MANPATH="/usr/local/man:$MANPATH"
