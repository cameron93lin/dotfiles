#!/bin/zsh

FUNCTION_DIR=$(dirname "$(perl -MCwd -e 'print Cwd::abs_path shift' "$0")")
SCRIPT_DIR=($(dirname $FUNCTION_DIR))
fastInstall() {
	echo "Installing from $SCRIPT_DIR/brew/$1..."
	echo "Will install following package by Homebrew:\n $(awk '{printf "%s ", $1}' $SCRIPT_DIR/brew/$1)"
	apple_script="tell app \"Terminal\"
	do script \"tmux new-session -d -s ptmux 'source $SCRIPT_DIR/util/fastInstall.sh $SCRIPT_DIR/brew/$1';tmux attach-session -t ptmux;exit\"
		set the position of the first window to {0, 0}
		set the bounds of the first window to {0, 22, 1920, 1080}
	end tell"

	osascript -e $apple_script

	tmux_running=($(ps aux|grep tmux|grep -v grep))
	while (($#tmux_running==0)) {
		sleep 1
		tmux_running=($(ps aux|grep tmux|grep -v grep))
	}
	echo "Installing... Do not close the popup terminal."
	until (($#tmux_running==0)) {
		sleep 1
		tmux_running=($(ps aux|grep tmux|grep -v grep))
	}

	echo "Finished Installing $SCRIPT_DIR/brew/$1"
}

add_to_applist() {
	applist+=($(awk '{print $1}' $SCRIPT_DIR/brew/$1))
}
installHomebrewApp() {
	brew update
	brew upgrade
	rm -rf $SCRIPT_DIR/brew/app_list.txt
	applist=()
	add_to_applist binaries

	# install common app
	add_to_applist common

	# install development app
	add_to_applist development

	# install personal app
	[[ $personal ]] && add_to_applist personal

	# install business app
	[[ $business ]] && add_to_applist business

	# install plugins for preview app
	# add more from https://github.com/sindresorhus/quick-look-plugins
	add_to_applist plugins

	add_to_applist amazon

	printf "%s\n" "${applist[@]}" >> $SCRIPT_DIR/brew/app_list.txt
	fastInstall app_list.txt
	export PATH="/usr/local/opt/curl/bin:$PATH"
}