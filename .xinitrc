#! /bin/sh

# Pass some env vars to systemd
systemctl --user import-environment DISPLAY

# Set xkbmap
setxkbmap -model pc105 -layout us,hu,ro -variant ,qwerty, -option grp:shifts_toggle

# Disable X screenlocker
xset s off -dpms

# Set numlock
# Refer to https://bugs.freedesktop.org/show_bug.cgi?id=78012
numlockx on

# Fill xrdb for the backup urxvt
xrdb ~/.Xresources

export SXHKD_SHELL='/bin/sh'
export TERMINAL='alacritty'
export WINIT_HIDPI_FACTOR="1.5"
export THEME=nord

exec bspwm -c $HOME/.bin/desktop/bspwmrc
