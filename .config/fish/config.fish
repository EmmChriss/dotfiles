## Environment

# Preferences
set -x EDITOR '/usr/bin/kak'
set -x VISUAL '/usr/bin/kak'
set -x PAGER  '/usr/bin/less'
set -x SHELL  '/usr/bin/fish'
set -x OPENER "$HOME/.config/lf/lfop"

# Defaults
set -x LESS       '-RS'
set -x BAT_THEME  'TwoDark'

## General
alias dotfiles='git --work-tree=$HOME --git-dir=$HOME/.dotfiles.git'
alias tmux="tmux -2 -f ~/.config/tmux.conf"
alias cat="bat -n || cat"

alias page="eval $PAGER"
alias sush="doas -s"

function lf -w 'lf'
	set tmp (mktemp)
	/usr/bin/lf -last-dir-path=$tmp $argv
	if test -f "$tmp"
		set dir (cat $tmp)
		rm -f "$tmp"
		if test -d "$dir" && test "$dir" != (pwd)
			cd $dir
		end
	end
end

## Bumblebee
alias bbstat='cat /proc/acpi/bbswitch'

function bbon
	echo ON > /proc/acpi/bbswitch
	bbstat
end

function bboff
	doas modprobe -r --remove-dependencies nvidia
	doas sh -c 'echo OFF > /proc/acpi/bbswitch'
	bbstat
end

## Fish config
bind \cf 'lf; commandline -f repaint'

function fish_greeting
	fortune
	echo
end

function fish_prompt --description "Write out the prompt"
	set -l color_cwd
	set -l suffix
	switch "$USER"
		case root toor
			if set -q fish_color_cwd_root
				set color_cwd $fish_color_cwd_root
			else
				set color_cwd $fish_color_cwd
			end
			set suffix '#'
		case '*'
			set color_cwd $fish_color_cwd
			set suffix '>'
	end
	
	echo -n -s "$USER" ' ' (set_color $color_cwd) (prompt_pwd) (set_color normal) "$suffix "
end

## Login stuff
if status is-login
	set -p PATH '/usr/repo/bin'
	set -p PATH "$HOME/.cargo/bin"
	
	set -x LS_COLORS (sh -c 'eval $(dircolors /etc/DIR_COLORS); echo $LS_COLORS')
	set -x SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"
	
	[ (tty) = "/dev/tty1" ]; and exec startx > /dev/null
end
