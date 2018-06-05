#!/bin/bash

# start with: C:\cygwin64\bin\mintty.exe '/cygdrive/c/Users/I863517/cygwin-start-urxvt/main.sh'
# issues occur when starting with bash.exe, process ownership related

function start_xwin_session {
    # start xwin server
    xwin_session="session_xwin_server"
    start_xwin_cmd="xwin -multiwindow -noclipboard"
    tmux new-session -t $xwin_session -d
    tmux send -t $xwin_session "$start_xwin_cmd"
    tmux send -t $xwin_session C-m
}

function start_urxvt_session {
    # start urxvt daemon
    urxvtd_session="session_urxvt_daemon"
    start_urxvtd_cmd="urxvtd"
    tmux new-session -t $urxvtd_session -d
    tmux send -t $urxvtd_session "$start_urxvtd_cmd"
    tmux send -t $urxvtd_session C-m
}

function start_urxvt_client {
    urxvtc -e tmux
}

function main {
    if ! [[ $(pidof xwin) ]]; then
        start_xwin_session
    fi

    if ! [[ $(pidof urxvtd) ]]; then
        start_urxvt_session
    fi

    start_urxvt_client
}

main