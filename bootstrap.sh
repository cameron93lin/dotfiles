#!/bin/zsh

[ -z "${BRANCH}" ] && export BRANCH="master"

# Detect environment
PLATFORM='unknown'
unamestr=$(uname)

if [[ "$unamestr" == 'Darwin' ]]; then
    PLATFORM='osx'
elif [[ "$unamestr" == 'Linux' ]]; then
    PLATFORM='linux'
fi

# Source local bootstrap overrides if present (gitignored)
[[ -f ~/dotfiles/bootstrap.local.sh ]] && source ~/dotfiles/bootstrap.local.sh

# Ensure git is available
if ! command -v git &>/dev/null; then
    if [[ "$PLATFORM" == 'osx' ]]; then
        echo "Check if Homebrew is installed..."
        which -s brew
        if [[ $? != 0 ]]; then
            echo "Homebrew not found! Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        brew install git
    else
        echo "git not found. Please install git first."
        exit 1
    fi
fi

# Clone or use existing dotfiles
if [[ -e ~/dotfiles ]]; then
    echo "~/dotfiles exist! Using existing directory"
else
    git clone --depth=1 -b ${BRANCH} https://github.com/cameron93lin/dotfiles.git ~/dotfiles
fi
cd ~/dotfiles

BASEDIR="$(cd "$(dirname "${0}")" >/dev/null && pwd)"

if [[ "$PLATFORM" == 'osx' ]]; then
    SETUP_FILE="$BASEDIR/script/osx.sh"
    if [[ -e $SETUP_FILE ]]; then
        . $SETUP_FILE $1
    else
        echo "Error: Missing setup file. Exiting."
        exit 1
    fi

    # Restore app preferences
    if [[ -f "$BASEDIR/cmux/com.cmuxterm.app.plist" ]]; then
        defaults import com.cmuxterm.app "$BASEDIR/cmux/com.cmuxterm.app.plist"
        echo "cmux preferences restored."
    fi
elif [[ "$PLATFORM" == 'linux' ]]; then
    echo "Setting up for Linux..."

    # Install starship
    mkdir -p ~/.config/bin
    if [[ ! -x ~/.config/bin/starship ]]; then
        echo "Installing starship..."
        curl -sLo /tmp/starship.tar.gz \
            https://github.com/starship/starship/releases/latest/download/starship-x86_64-unknown-linux-musl.tar.gz
        tar -xzf /tmp/starship.tar.gz -C ~/.config/bin starship 2>/dev/null
    fi

    # Install zoxide
    if [[ ! -x ~/.config/bin/zoxide ]]; then
        echo "Installing zoxide..."
        curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh -s -- --bin-dir ~/.config/bin
    fi

    # Symlink configs
    mkdir -p ~/.config/zshrc/modules
    ln -sf ~/dotfiles/zshrc/.config/zshrc/dot-zshrc ~/.config/zshrc/.zshrc
    for f in ~/dotfiles/zshrc/.config/zshrc/modules/*.zsh; do
        ln -sf "$f" ~/.config/zshrc/modules/
    done
    ln -sf ~/dotfiles/tmux/dot-tmux.conf ~/.tmux.conf
    ln -sf ~/dotfiles/starship/.config/starship.toml ~/.config/starship.toml 2>/dev/null

    echo "Linux setup complete! Run 'source ~/.config/zshrc/.zshrc' or open a new shell."
else
    echo "Error: $PLATFORM is not supported. Exiting."
    exit 1
fi

exit 0
