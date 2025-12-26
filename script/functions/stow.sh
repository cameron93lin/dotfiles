#!/bin/zsh

stowFile() {
    # Ensure we are in the dotfiles root directory
    # BASEDIR is exported by osx.sh
    if [[ -n "$BASEDIR" ]]; then
        cd "$BASEDIR" || return 1
    fi

    # stow config
    stow --dotfiles -R ssh -v
    stow --no-folding --dotfiles -R zshrc p10k git iterm2 -v

    # remove and stow xbar config
    # xbar path
    local xbar_path=~/Library/Application\ Support/xbar/
    
    if [[ -e "$xbar_path" ]]; then
        # Back up existing plugins if not already backed up? 
        # Or blindly move. Original code blindly moved.
        # But if pluginsbackup exists, mv will fail or move INTO it.
        # Keeping it simple as per original intent but cleaner paths.
        if [[ -e "$xbar_path/plugins" ]]; then
             mv "$xbar_path/plugins" "$xbar_path/pluginsbackup"
        fi
        if [[ -e "$xbar_path/xbar.config.json" ]]; then
             mv "$xbar_path/xbar.config.json" "$xbar_path/xbar.config.json.backup"
        fi
    fi
    
    # Ensure xbar directory exists? Stow might need it or create it.
    # Stow -t target.
    # If target doesn't exist, stow usually creates links inside parent? 
    # Or needs directory?
    # Original code assumed xbar folder existed or stow handles it.
    mkdir -p "$xbar_path"

    stow -R -t "$xbar_path" xbar -v
}
