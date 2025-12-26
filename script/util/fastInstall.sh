#!/bin/zsh

# Function to send a command to a tmux pane
tmux_exec() {
  local pane_index=$1
  local command=$2
  tmux send-keys -t "$pane_index" C-z "$command" ENTER
}

# Function to update the list of available processes (panes with default bg)
update_available_processes() {
    # Panes with default background are considered available.
    # Exclude pane 0 (the controller).
    available_processes=( $(tmux list-panes -af "#{&&:#{==:#{pane_bg},default},#{!=:#P,0}}" -F "#P") )
}

file=$1
max_process=4
apps=($(awk '{print $1}' "$file"))
available_processes=()

# Resolve SCRIPT_DIR. This script is in script/util/fastInstall.sh
# We want SCRIPT_DIR to be .../script
CURRENT_DIR=${0:A:h}
SCRIPT_DIR=${CURRENT_DIR:h}

# Split windows for parallel processing
for i in {1..$max_process}; do
  tmux split-window
done

tmux select-layout tiled
tmux set-option -g mouse on

installed=0

for app in "${apps[@]}"; do
  sleep 1
  # Execute the script directly instead of sourcing
  tmux_command="$SCRIPT_DIR/util/brew_install.sh $app"
  
  update_available_processes
  echo "Installing: $app"
  
  # Wait for an available pane
  while [[ ${#available_processes[@]} -eq 0 ]]; do
    sleep 1
    update_available_processes
  done

  target_pane=${available_processes[1]}
  
  echo "Assigning $app to pane $target_pane"
  tmux_exec "$target_pane" "$tmux_command $target_pane"
  
  ((++installed))
  echo "Installed count: $installed"
done

# Wait for all processes to finish
while true; do
    update_available_processes
    total_worker_panes=$(tmux list-panes -af "#{!=:#P,0}" | wc -l)
    # If all worker panes are available (default bg), we are done.
    if [[ ${#available_processes[@]} -eq $total_worker_panes ]]; then
        break
    fi
    sleep 1
done

tmux kill-session -t ptmux