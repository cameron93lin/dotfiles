#!/bin/zsh
tmux select-pane -t $2 -P "bg=black"
while true; do
    brew install $1;
    if [ $? -eq 0 ]; then
        break;
    else
        read "retry?mission fail, retry? (Y/N)[n]";
        case $retry in
            [Yy]* ) continue;;
                * ) break;;
        esac
    fi;
done
tmux select-pane -t $2 -P "bg=default"