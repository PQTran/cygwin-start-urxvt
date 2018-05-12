#!/bin/bash

# start X server
if ! [[ $(pidof xwin) ]]; then
    xwin -multiwindow -noclipboard &
fi

# start urxvt daemon
if ! [[ $(pidof urxvtd) ]]; then
    urxvtd &
fi

# open urxvt client
urxvtc
