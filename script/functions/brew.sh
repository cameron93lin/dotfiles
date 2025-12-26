#!/bin/zsh

# Resolve directory of this script (brew.sh is in script/functions)
# Using %x to get the source file path when sourced
FUNCTION_DIR=${${(%):-%x}:A:h}
SCRIPT_DIR=${FUNCTION_DIR:h} # points to .../script

fastInstall() {
    local list_file=$1
    local list_path="$SCRIPT_DIR/brew/$list_file"
    
    if [[ ! -f "$list_path" ]]; then
        echo "Error: List file $list_path not found."
        return 1
    fi

    echo "Installing packages from $list_file..."
    
    # Get list of packages using awk to grab first column
    local packages=($(awk '{print $1}' "$list_path"))
    
    for package in "${packages[@]}"; do
        if brew list "$package" &>/dev/null; then
            echo "Skipping $package (already installed)"
            continue
        fi

        echo "--------------------------------------------------"
        echo "Installing: $package"
        echo "--------------------------------------------------"
        brew install "$package"
        
        if [[ $? -eq 0 ]]; then
            echo "Successfully installed $package"
        else
            echo "Error installing $package. Continuing..."
        fi
    done

    echo "Finished Installing $list_file"
}

add_to_applist() {
    local list_name=$1
    if [[ -f "$SCRIPT_DIR/brew/$list_name" ]]; then
        applist+=($(awk '{print $1}' "$SCRIPT_DIR/brew/$list_name"))
    else
        echo "Warning: App list '$list_name' not found at $SCRIPT_DIR/brew/$list_name"
    fi
}

generateAppList() {
    applist=()
    add_to_applist binaries
    add_to_applist common
    add_to_applist development
    [[ -n "$personal" ]] && add_to_applist personal
    [[ -n "$business" ]] && add_to_applist business
    add_to_applist plugins
    [[ -n "$amazon" ]] && add_to_applist amazon
}

showAppList() {
    generateAppList
    # Join array with newlines
    local list_str="${(F)applist}"
    
    if command -v whiptail &> /dev/null; then
        whiptail --title "App Install List" --scrolltext --msgbox "The following applications will be installed:\n\n$list_str" 20 70
    else
        echo "The following applications will be installed:"
        echo "$list_str"
        echo "Press Enter to continue..."
        read
    fi
}

installHomebrewApp() {
    brew update
    brew upgrade
    
    local app_list_file="$SCRIPT_DIR/brew/app_list.txt"
    rm -f "$app_list_file"
    
    generateAppList

    printf "%s\n" "${applist[@]}" >> "$app_list_file"
    fastInstall app_list.txt
    export PATH="/usr/local/opt/curl/bin:$PATH"
}
