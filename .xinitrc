#! /bin/sh

# pass some env vars to systemd
systemctl --user import-environment DISPLAY PATH 

# set xkbmap
setxkbmap -model pc105 -layout us,hu,ro -variant ,qwerty, -option grp:shifts_toggle

# disable X screenlocker
xset s off -dpms

# increase key rate
xset r rate 300 50

# enable tapping
#xinput set-prop 'SynPS/2 Synaptics TouchPad' 'Synaptics Tap Action' 0 0 0 0 1 2 3
xinput set-prop 'SynPS/2 Synaptics TouchPad' 'libinput Tapping Enabled' 1

# set numlock
# https://bugs.freedesktop.org/show_bug.cgi?id=78012
numlockx &

xrdb ~/.Xresources

exec bspwm -c $HOME/.bin/desktop/bspwmrc
