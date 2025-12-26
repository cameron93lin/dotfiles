#!/bin/zsh

ensure_xcode_tools() {
    echo "Check if Xcode command line tools is installed..."
    xcode-select -p 1>/dev/null
    if [[ $? != 0 ]]; then
        echo "Xcode command line tools is not installed! Installing Xcode command line tool..."
        sudo xcode-select --install
        echo "Finish xcode-select installation!"
    else
        echo "Xcode command line tools is installed."
    fi
}

ensure_homebrew() {
    echo "Check if Homebrew is installed..."
    if ! command -v brew &> /dev/null; then
        echo "Homebrew not found! Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add brew to shellenv for immediate use
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        elif [[ -f "/usr/local/bin/brew" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        fi
        
        echo "Finish homebrew installation!"
    else
        echo "Homebrew is installed!"
    fi
}

ensure_whiptail() {
    echo "Check if whiptail is installed..."
    if ! command -v whiptail &> /dev/null; then
        echo "Whiptail not found! Installing newt (provides whiptail)..."
        brew install newt
        echo "Finish Whiptail installation!"
    else
        echo "Whiptail is installed!"
    fi
}

get_setup_type() {
    local arg_type=$1
    local chosen_type=""

    if [[ -n "$arg_type" ]]; then
        chosen_type=$arg_type
    else
        # Interactive selection
        chosen_type=$(whiptail --title "Choose setup type" --radiolist \
        "What is the setup type? Use 'Space' to select options 
 Use 'TAB' to select [OK] or [Cancel] button 
 " \
        15 60 4 \
        "amazon" "For Amazon" OFF \
        "personal" "For personal" OFF \
        "business" "For business" OFF \
        "test" "Test option" ON  3>&1 1>&2 2>&3)
    fi

    echo "$chosen_type"
}

setup_nerd_fonts() {
    echo "Installing Nerd Fonts..."
    # Run in background as it takes time
    (
        git clone https://github.com/ryanoasis/nerd-fonts.git --depth 1 /tmp/nerd-fonts
        cd /tmp/nerd-fonts
        ./install.sh Meslo
        cd ..
        rm -rf /tmp/nerd-fonts
        echo "Nerd Fonts installed."
    ) &
}

setup_mas_apps() {
    echo "Installing Mac App Store apps..."
    brew install mas
    # Verify we are logged in or warn? mas cannot login via CLI on newer macOS easily.
    # Assuming user is logged in.
    # Installing Xcode via mas is huge, keeping logic but warning.
    echo "Searching for Xcode in MAS..."
    mas search Xcode | head -1 | awk '{ print $1 }' | xargs mas install
}

setup_vscode() {
    echo "Setting up Visual Studio Code..."
    # install 'code' command in terminal
    if [[ -d "/Applications/Visual Studio Code.app" ]]; then
        sudo ln -sf "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" /usr/local/bin/code
        
        # install Visual Studio Code extension 'SettingSync' (Deprecated in favor of built-in sync, but keeping per request)
        if command -v code &> /dev/null; then
            code --install-extension Shan.code-settings-sync
        fi
    else
        echo "Visual Studio Code app not found in /Applications"
    fi
}

configure_terminal() {
    echo "Configuring Terminal fonts..."
    osascript <<EOD
    tell application "Terminal"
        set ProfilesNames to name of every settings set
        repeat with ProfileName in ProfilesNames
        set font name of settings set ProfileName to "MesloLGS Nerd Font"
        set font size of settings set ProfileName to 14
        end repeat
    end tell
EOD
}

setup_alfred_theme() {
    echo "Setting up Alfred theme..."
    # BASEDIR is exported in osx.sh
    local theme_path="$BASEDIR/alfred_themes/almost cloudy.alfredappearance"
    
    if [[ -f "$theme_path" ]]; then
        # Check for Alfred
        if ls /Applications/Alfred* &> /dev/null; then
             echo "Importing Alfred theme..."
             open "$theme_path"
        else
             echo "Alfred not found. Please install Alfred first."
        fi
    else
        echo "Alfred theme file not found at $theme_path"
    fi
}