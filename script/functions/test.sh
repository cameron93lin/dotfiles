#!/bin/zsh
testFunction() {
  echo "Testing script"
  #source "$SCRIPT_DIR:h/script/test.sh"
echo "start test"
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "$SCRIPT_DIR:h/iTerm2/"
echo "finish test"
}

# fastInstall() {
# 	local file=$1
# 	local total=$#
# 	local installed=0
# 	local max_process=4
# 	local current_process=0
# 	local app_array=($(awk '{print $1}' $file))

# 	command_wrapper="
# 	while true; do
# 			brew install %s;
# 			if [ \$\? -eq 0 ]; then
# 					break;
# 			else
# 					read -p \"mission fail, retry? (Y/N)[n]\" retry;
# 					case \$retry in
# 							[Yy]* ) continue;;
# 									* ) break;;
# 					esac
# 			fi;
# 	done
# 	"
# 	tmux new-session -d -s ptmux ''
# 	# tmux new-window 'sleep 1 && echo test'
# 	# tmux select-window -t ptmux:0
# 	# tmux split-window 'sleep 1 && echo test'
# 	# tmux split-window 'sleep 1 && echo test'
# 	tmux select-layout tiled
# 	tmux set-option -g mouse on
# 	# tmux attach-session -t ptmux
#   for app in "${app_array[@]}"; do
# 		tmux_command=$(printf $command_wrapper $app)
#     while [[ $(tmux list-panes -F '#{window_panes}') == 4 ]] {
# 			sleep 1
#     }
# 		if (( $(tmux list-panes -F '#{window_panes}') < 4 )) {
# 			tmux split-window $tmux_command
# 		}
#     ((++installed))
# 	done
# }



# # # echo $FUNCTION_DIR
# # # echo $(dirname $FUNCTION_DIR)
# # # echo $(dirname $(dirname $FUNCTION_DIR))
# # # echo $SCRIPT_DIR
# # # # brew update
# # # # brew upgrade
# # # echo $SCRIPT_DIR
# FUNCTION_DIR=$(dirname "$(perl -MCwd -e 'print Cwd::abs_path shift' "$0")")
# SCRIPT_DIR=($(dirname $FUNCTION_DIR))
# apple_script="tell app \"Terminal\"
#    do script \"tmux new-session -d -s ptmux 'source $FUNCTION_DIR/fastInstall.sh $SCRIPT_DIR/brew/test&&echo finish&&sleep 5';tmux attach-session -t ptmux;exit\"
# 	set the position of the first window to {0, 0}
# 	set the bounds of the first window to {0, 22, 1920, 1080}
# end tell"

# # apple_script="tell app \"Terminal\"
# #    do script \"printf \'\\e\\[8\;60\;150t\'\"
# # end tell"
# # echo $apple_script
# osascript -e $apple_script

# tmux_running=($(ps aux|grep tmux|grep -v grep))
# while (($#tmux_running==0)) {
# 	sleep 1
# 	tmux_running=($(ps aux|grep tmux|grep -v grep))
# }

# until (($#tmux_running==0)) {
# 	sleep 1
# 	tmux_running=($(ps aux|grep tmux|grep -v grep))
# }

# echo "Script finished"


run_login() {

login_script="do script \\\"zsh $SCRIPT_DIR/login/install.sh\\\""

/usr/libexec/PlistBuddy $SCRIPT_DIR/login/dotfiles.installer.plist -c "Set :ProgramArguments:4 \"$login_script\""
cp $SCRIPT_DIR/login/dotfiles.installer.plist ~/Library/LaunchAgents/dotfiles.installer.plist
chmod 644 ~/Library/LaunchAgents/dotfiles.installer.plist
launchctl load ~/Library/LaunchAgents/dotfiles.installer.plist
launchctl start dotfilesInstaller
# osascript -e 'tell application "System Events" to log out'
}



# tmux new-session -d -s ptmux "source $FUNCTION_DIR/fastInstall.sh $SCRIPT_DIR/brew/binaries"
# tmux attach-session -t ptmux

# current_process=$(tmux list-panes -F '#{window_panes}')
# echo $current_process

# if (( $(tmux list-panes -F '#{window_panes}') < 4 )) {
# 	echo 'yes'
# }
# app_array=($(awk '{print $1}' ~/dotfiles/script/brew/binaries))

# for app in "${app_array[@]}"
# do
#   echo $app
# done
# echo $myarray
# content=$(cat ~/dotfiles/script/brew/binaries)
# fastInstall $(awk '{print $1}' ~/dotfiles/script/brew/binaries)
# getArray "~/dotfiles/script/brew/binaries"
# for e in "${array[@]}"
# do
#     echo "$e"
# done
# for line in "${(@f)"$(<~/dotfiles/script/brew/binaries)"}"
# {
#   fastInstall $line
# }
# cat ~/dotfiles/script/brew/binaries | xargs -d' ' -t -n1 -P2 fastInstall
# # xcode-select -p 1>/dev/null;
# if [[ -x "$(command -v rbenv)" ]] {
#   echo "yes"
# } else {
#   echo "no"
# }
# echo "finish"
# # customize with your own.
# options=("AAA" "BBB" "CCC" "DDD")

# menu() {
#     echo "Avaliable options:"
#     for i in ${!options[@]}; do
#         printf "%3d%s) %s\n" $((i+1)) "${choices[i]:- }" "${options[i]}"
#     done
#     if [[ "$msg" ]]; then echo "$msg"; fi
# }

# prompt="Check an option (again to uncheck, ENTER when done): "
# while menu && read -rp "$prompt" num && [[ "$num" ]]; do
#     clear
#     [[ "$num" != *[![:digit:]]* ]] &&
#     (( num > 0 && num <= ${#options[@]} )) ||
#     { msg="Invalid option: $num"; continue; }
#     ((num--)); msg="${options[num]} was ${choices[num]:+un}checked"
#     [[ "${choices[num]}" ]] && choices[num]="" || choices[num]="+"
# done

# printf "You selected"; msg=" nothing"
# for i in ${!options[@]}; do
#     [[ "${choices[i]}" ]] && { printf " %s" "${options[i]}"; msg=""; }
# done
# echo "$msg"