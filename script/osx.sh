#!/bin/zsh

FUNCTION_DIR=$(dirname "$(perl -MCwd -e 'print Cwd::abs_path shift' "$0")")
SCRIPT_DIR=($(dirname $FUNCTION_DIR))
# Include all subscripts
for scripts in $BASEDIR/script/functions/*.sh; do source "$scripts"; done

clear

echo "Check if Xcode command line tools is installed..."
xcode-select -p 1>/dev/null;echo $?
if [[ $? != 0 ]] {
    echo "Xcode command line tools is not installed! Installing Xcode command line tool..."
    sudo xcode-select --install
    echo "Finish xcode-select installation!"
} else {
echo "Xcode command line tools"
}

echo "Check if Homebrew is installed..."
which -s brew
if [[ $? != 0 ]] {
    echo "Homebrew not found! Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "Finish homebrew installation!"
} else {
    echo "Homebrew is installed!"
}

echo "Check if whiptail is installed..."
# install whiptail for shell user interface
if [[ ! -f /usr/local/bin/whiptail ]] {
    echo "Whiptail not found! Installing Whiptail for user interface..."
    brew install newt
    echo "Finish Whiptail installation!"
} else {
    echo "Whiptail is installed!"
}

sleep 1

SETUP_TYPE=$(whiptail --title "Choose setup type" --radiolist \
"What is the setup type?\n Use 'Space' to select options \n Use 'TAB' to select [OK] or [Cancel] button \n " 15 60 4 \
"amazon" "For Amazon" OFF \
"personal" "For personal" OFF \
"business" "For business" OFF \
"test" "Test option" ON  3>&1 1>&2 2>&3)
exitstatus=$?

    printf "Setting up for %s\n" $SETUP_TYPE
    case $1 {
    ("test")
    test=1
    ;;
    ("personal")
    personal=1
    ;;
    ("business")
    business=1
    ;;
    ("amazon")
    amazon=1
    ;;
    }

    
    # running test function for testing commond
    [[ $test ]] && testFunction && exit 0

    [[ $amazon ]] && amazonSetup && exit 0
    installHomebrewApp
    stowFile
    macosSetup
    [[ $amazon ]] && amazonSetup

    # install nerd-fonts
    git clone https://github.com/ryanoasis/nerd-fonts.git --depth 1&&cd nerd-fonts&&./install.sh&&cd ..&&rm -rf nerd-fonts &
    brew install mas
    mas search Xcode | head -1 | awk '{ print $1 }' | xargs mas install

    # install 'code' command in terminal for Visual Studio Code
    sudo ln -s  /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code /usr/local/bin/code

    # install Visual Studio Code extension 'SettingSync'
    code --install-extension Shan.code-settings-sync
    
osascript <<EOD
    tell application "Terminal"
        set ProfilesNames to name of every settings set
        repeat with ProfileName in ProfilesNames
        set font name of settings set ProfileName to "MesloLGS Nerd Font"
        set font size of settings set ProfileName to 14
        end repeat
    end tell
EOD
echo "exit"
exit 0