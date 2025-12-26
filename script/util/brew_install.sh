#!/bin/zsh

# Ensure brew is in PATH
if ! command -v brew &> /dev/null; then
    if [[ -x /opt/homebrew/bin/brew ]]; then
        export PATH="/opt/homebrew/bin:$PATH"
    elif [[ -x /usr/local/bin/brew ]]; then
        export PATH="/usr/local/bin:$PATH"
    fi
fi

APP=$1
PANE_INDEX=$2

# Set pane background to indicate active work
tmux select-pane -t "$PANE_INDEX" -P "bg=black"

MAX_RETRIES=3
count=0

while true; do
    echo "Attempting to install $APP..."
    brew install "$APP"
    
    if [ $? -eq 0 ]; then
        echo "Successfully installed $APP"
        break
    else
        echo "Installation of $APP failed."
        ((count++))
        if [[ $count -lt $MAX_RETRIES ]]; then
             echo "Retrying in 2 seconds (Attempt $count/$MAX_RETRIES)..."
             sleep 2
             continue
        fi

        # Ask user for manual retry if auto-retries fail
        echo -n "Mission failed for $APP. Retry? (y/n) [n]: "
        # read -q reads a single character. Returns 0 (true) if 'y' or 'Y'.
        if read -q response; then
             echo # newline
             count=0 # Reset counter
             continue
        else
             echo # newline
             echo "Skipping $APP"
             break
        fi
    fi
done

# Reset pane background
tmux select-pane -t "$PANE_INDEX" -P "bg=default"
