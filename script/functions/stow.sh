#!/bin/zsh

stowFile() {

# stow config
stow --dotfiles -R ssh -v
stow --no-folding --dotfiles -R zshrc p10k git iterm2 -v

# remove and stow xbar config
if [[ -e ~/Library/Application\ Support/xbar/ ]] {
    mv ~/Library/Application\ Support/xbar/plugins ~/Library/Application\ Support/xbar/pluginsbackup
    mv ~/Library/Application\ Support/xbar/xbar.config.json ~/Library/Application\ Support/xbar/xbar.config.json.backup
}
stow -R -t ~/Library/Application\ Support/xbar/ xbar -v
}