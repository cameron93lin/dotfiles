#!/bin/zsh

# Define paths
# SCRIPT_DIR points to .../script
SCRIPT_DIR=${0:A:h}
# PROJECT_ROOT points to .../dotfiles
PROJECT_ROOT=${SCRIPT_DIR:h}
export BASEDIR=$PROJECT_ROOT # Maintain compatibility if BASEDIR is used elsewhere

# Include all functions
for scripts in "$SCRIPT_DIR"/functions/*.sh; do source "$scripts"; done

clear

ensure_xcode_tools
ensure_homebrew
ensure_whiptail

sleep 1

SETUP_TYPE=$(get_setup_type "$1")
exitstatus=$?

if [[ $exitstatus != 0 ]]; then
    echo "Setup cancelled."
    exit 1
fi

printf "Setting up for %s\n" $SETUP_TYPE

# Set flags based on SETUP_TYPE
case $SETUP_TYPE in
    "test")
        test=1
        ;;
    "personal")
        personal=1
        ;;
    "business")
        business=1
        ;;
    "amazon")
        amazon=1
        ;;
esac

# running test function for testing command
[[ $test ]] && testFunction && exit 0

[[ $amazon ]] && amazonSetup && exit 0

showAppList

installHomebrewApp
stowFile
macosSetup

[[ $amazon ]] && amazonSetup

setup_nerd_fonts
setup_mas_apps
setup_vscode
configure_terminal
setup_alfred_theme

echo "exit"
exit 0
