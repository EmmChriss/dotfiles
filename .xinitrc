#! /bin/bash

# set xkbmap
setxkbmap -model pc105 -layout us,hu,ro -variant ,qwerty, -option grp:shifts_toggle

# disable X screenlocker
xset s off -dpms

# increase key rate
xset r rate 300 50

# enable tapping
xinput set-prop 'MSFT0001:00 04F3:3186 Touchpad' 'libinput Tapping Enabled' 1

# set numlock
# https://bugs.freedesktop.org/show_bug.cgi?id=78012
numlockx &

xrdb ~/.Xresources

# setup prime offloading
prime-offload

export TERMINAL=alacritty
export BROWSER=opera
export EDITOR=hx
export VISUAL=hx
export PAGER=less
export OPERNER=xdg-open
eval $(dircolors $HOME/.config/DIR_COLORS)

# pass some env vars to systemd
systemctl --user import-environment PATH DISPLAY XAUTHORITY DBUS_SESSION_BUS_ADDRESS LS_COLORS SXHKD_SHELL _JAVA_AWT_WM_NONREPARENTING _JAVA_OPTIONS \
  TERMINAL BROWSER EDITOR VISUAL PAGER OPENER

# trigger graphical.target
systemctl --user --no-block start xsession.target

# start stuff
bspwm
