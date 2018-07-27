#!/bin/bash

# start with: C:\cygwin64\bin\mintty.exe '/cygdrive/c/Users/I863517/cygwin-start-urxvt/main.sh' start
# issues occur when starting with bash.exe, process ownership related

# instead of fixed times, place waits based on pid of processes

tmux_config="/cygdrive/c/Users/I863517/.tmux.d/.tmux.conf"

xwin_session="session_xwin_server"
urxvtd_session="session_urxvt_daemon"

function start_xwin_session {
    # start xwin server
    start_xwin_cmd="xwin -multiwindow -noclipboard"
    tmux -f $tmux_config new-session -t $xwin_session -d
    tmux send -t $xwin_session "$start_xwin_cmd"
    tmux send -t $xwin_session C-m
}

function start_urxvt_session {
    # start urxvt daemon
    start_urxvtd_cmd="urxvtd"
    tmux -f $tmux_config new-session -t $urxvtd_session -d
    tmux send -t $urxvtd_session "$start_urxvtd_cmd"
    tmux send -t $urxvtd_session C-m
}

function start_urxvt_client {
    urxvtc -e tmux
}

function tmux_has_session {
    session_name=$1

    if [[ $(tmux list-sessions | grep -c "$session_name") -eq 0 ]]; then
        return 0
    else
        return 1
    fi
}

function tmux_kill_session {
    session_name=$1

    tmux kill-session -t "$session_name"
}

function start {
    if ! [[ $(pidof xwin) ]]; then
        echo "starting xwin"
        sleep 1
        start_xwin_session
    fi

    if ! [[ $(pidof urxvtd) ]]; then
        echo "starting urxvtd"
        sleep 1
        start_urxvt_session
    fi

    echo "starting urxvtc"
    sleep 2
    start_urxvt_client

    iteration=0
    while ! [[ $(pidof tmux) ]]; do
        let iteration+=1

        sleep 1
    done
}

function cleanup {
    urxvtd_pid=$(pidof urxvtd)
    if [[ $urxvtd_pid ]]; then
        echo "killing urxvtd"
        sleep 1
        kill -9 $urxvtd_pid
    fi

    xwin_pid=$(pidof xwin)
    if [[ $xwin_pid ]]; then
        echo "killing xwin"
        kill -9 $xwin_pid
    fi

    for PID in $(pidof tmux); do
        kill -9 $PID
    done
}

function main {
    action=$1

    case "$action" in
        start)
            cleanup
            start
            ;;
        cleanup)
            cleanup
            ;;
        *)
            echo "Unrecognized action"
            sleep 3
            exit 1
    esac
}

# $1 action
main $1