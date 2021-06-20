#!/bin/zsh

[ -z "${BRANCH}" ] && export BRANCH="master"

echo "Check if Homebrew is installed..."
which -s brew
if [[ $? != 0 ]] {
    echo "Homebrew not found! Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "Finish homebrew installation!"
} else {
    echo "Homebrew is installed!"
}
brew install git
if [[ -e ~/dotfiles ]] {
  echo "~/dotfiles exist! Use ~/dotfiles as directory for following script"
} else {
  git clone --depth=1 -b ${BRANCH} https://github.com/cameron93lin/dotfiles.git ~/dotfiles
}
cd ~/dotfiles

SCRIPT_DIR=$(perl -MCwd -e 'print Cwd::abs_path shift' "$0")

# Check for OS X
PLATFORM='unknown'
unamestr=$( uname )

if [[ "$unamestr" == 'Darwin' ]]; then
    PLATFORM='osx'
else
    echo "Error: $PLATFORM is not supported. Exiting."
    exit 1
fi

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

SETUP_FILE="$BASEDIR/script/$PLATFORM.sh"

if [[ -e $SETUP_FILE ]]
then
  . $SETUP_FILE $1
else
  echo "Error: Missing setup file. Exiting."
  exit 1
fi

exit 0
