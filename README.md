# macOS Dotfiles Bootstrap

This repository contains a comprehensive set of dotfiles and a bootstrap script to automate the setup of a new macOS environment. It configures the system, installs essential applications via Homebrew, and manages configuration files using GNU Stow.

## Features

-   **Automated Setup:** A single `bootstrap.sh` script to kickstart the entire process.
-   **Interactive Installation:** Uses `whiptail` to present a menu, allowing you to choose between different setup profiles (e.g., Personal, Business, Amazon).
-   **Package Management:** Automatically installs Homebrew and manages applications (GUI and CLI) using lists defined in `script/brew/`.
-   **Configuration Management:** Uses GNU `stow` to symlink configuration files for:
    -   `zsh` (with Powerlevel10k)
    -   `git`
    -   `ssh`
    -   `iTerm2`
    -   `xbar`
-   **System Customization:** Applies sensible defaults and tweaks for macOS (Finder, Dock, Keyboard, Trackpad, etc.) via `script/functions/macos.sh`.
-   **Developer Tools:** Sets up VS Code, IntelliJ, CLion, and installs Nerd Fonts.

## Installation

### One-Line Install

You can run the bootstrap script directly from the terminal:

```bash
curl https://raw.githubusercontent.com/cameron93lin/dotfiles/master/bootstrap.sh | zsh
```

### Manual Install

1.  Clone the repository:
    ```bash
    git clone https://github.com/cameron93lin/dotfiles.git ~/dotfiles
    ```
2.  Navigate to the directory:
    ```bash
    cd ~/dotfiles
    ```
3.  Run the bootstrap script:
    ```bash
    ./bootstrap.sh
    ```

## What's Included

The setup installs a variety of tools and applications based on the selected profile.

### Core Utilities
-   **Homebrew:** The missing package manager for macOS.
-   **Oh My Zsh / Powerlevel10k:** Enhanced shell experience.
-   **GNU Stow:** Symlink farm manager.

### Common Applications
Defined in `script/brew/common`:
-   **Browsers:** Google Chrome, Firefox
-   **Productivity:** Alfred, OmniFocus, Caffeine, Keka
-   **System Enhancements:** iTerm2, Karabiner-Elements, BetterTouchTool, xbar

### Development Tools
Defined in `script/brew/development`:
-   **IDEs/Editors:** Visual Studio Code, IntelliJ IDEA, CLion
-   **Docs:** Dash
-   **Fonts:** MesloLGS Nerd Font (and others via `nerd-fonts` repo)

## Directory Structure

-   `bootstrap.sh`: The entry point for the installation.
-   `script/`: Contains all installation logic.
    -   `osx.sh`: Main script for macOS setup.
    -   `functions/`: Helper scripts for specific tasks (`brew.sh`, `stow.sh`, `macos.sh`).
    -   `brew/`: Text files listing packages to be installed (`common`, `development`, etc.).
-   `zshrc/`, `git/`, `ssh/`, `iTerm2/`, `p10k/`, `xbar/`: Configuration directories to be stowed.

## macOS Customizations

The `macosSetup` function in `script/functions/macos.sh` applies various system preferences, including:
-   Disabling startup sound.
-   Configuring Dock orientation and behavior.
-   Enabling "Tap to Click" and "Three Finger Drag".
-   Optimizing Finder (showing path bar, status bar, and all file extensions).
-   Disabling auto-correct and smart quotes.
-   Configuring screenshot locations and formats.