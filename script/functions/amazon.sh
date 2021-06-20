#!/bin/zsh

amazonSetup() {
  source $FUNCTION_DIR/brew.sh
  brew update
  brew upgrade

  fastInstall amazon
}
