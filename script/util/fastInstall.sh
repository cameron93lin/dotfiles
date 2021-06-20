#!/bin/zsh
tmux_exec() {
  local target=$1
  local command=$2
  tmux send-keys -t $1 C-z $2 ENTER
}

update_avaliable_process() {
    avaliable_process=( `tmux list-panes -af "#{&&:#{==:#{pane_bg},default},#{!=:#P,0}}" -F "#P"` )
    total_process=( `tmux list-panes -af "#{!=:#P,0}" -F "#P"` )
}
local file=$1
local total=$#
local installed=0
local max_process=4
local current_process=0
local app_array=($(awk '{print $1}' $file))
local avaliable_process=()
local total_process=()

FUNCTION_DIR=$(dirname "$(perl -MCwd -e 'print Cwd::abs_path shift' "$0")")
SCRIPT_DIR=($(dirname $FUNCTION_DIR))
for i ({1..$max_process}) {
  tmux split-window
}
echo "splited"
tmux select-layout tiled
tmux set-option -g mouse on
for app in "${app_array[@]}"; do
  sleep 1
  tmux_command="source $SCRIPT_DIR/util/brew_install.sh $app"
  update_avaliable_process
  echo $app
  echo "Current process $#avaliable_process"
  echo $avaliable_process
  while [[ $#avaliable_process == 0 ]] {
    sleep 1
    update_avaliable_process
    echo "Current process in while loop $#avaliable_process"
    echo $avaliable_process
  }
  echo $command_wrapper
  tmux_exec $avaliable_process[1] "$tmux_command $avaliable_process[1]"
  echo "run-shell on $avaliable_process[1]"
  ((++installed))
  echo "installed $installed"
done
while [[ $#avaliable_process < $#total_process ]] {
  sleep 1
  update_avaliable_process
}

tmux kill-session -t ptmux
