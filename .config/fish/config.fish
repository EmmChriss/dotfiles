# Environment

# on login
if status is-login && [ (tty) = '/dev/tty1' ]
	echo "[0] Only AMD"
	echo "[1] PRIME"
	read -p "echo '(0) '" -n 1 answer
	
	if [ $answer = 1 ]
		# PRIME
		
		# switch drivers
		while lsmod | grep -q nouveau
			sudo rmmod nouveau
			sleep 1
		end
		lsmod | grep -q nvidia || sudo modprobe nvidia nvidia_uvm nvidia_modeset nvidia_drm
		sudo nvidia-smi -pm 1
	else
		# AMD
		
		# switch drivers
		while lsmod | grep -q nvidia
			sudo nvidia-smi -pm 0
			sudo rmmod nvidia nvidia_uvm nvidia_modeset nvidia_drm
			sleep 1
		end
		lsmod | grep -q nouveau || sudo modprobe nouveau
	end
	
	exec startx
end

# Preferences
set -x LS_COLORS (sh -c 'eval $(dircolors $HOME/.config/DIR_COLORS); echo $LS_COLORS')
set -x LESS       '-RS'
set -x BAT_THEME  'TwoDark'

# aliases
alias tmux='tmux -2'
alias ssh='env TERM=xterm-color ssh'
alias cli-ref='curl -s "http://pastebin.com/raw/yGmGiDQX" | less -i'
alias ls='ls -lh --group-directories-first --color=auto'

alias gs='git status'
alias gd='git diff'
alias gl='git log'
alias gmv='git mv'
alias grm='git rm'

alias page="eval $PAGER"
alias sush="sudo -s"

alias bt="bluetoothctl"

# lf alias

function lf -w 'lf'
	set tmp (mktemp)
	command lf -last-dir-path=$tmp $argv
	if test -f "$tmp"
		set dir (cat $tmp)
		rm -f "$tmp"
		if test -d "$dir" && test "$dir" != (pwd)
			cd $dir
		end
	end
end

# ssh-agent
function ssh-agent
	set -l TMP_SSH (/usr/bin/ssh-agent)
	set -x SSH_AUTH_SOCK (echo $TMP_SSH | tr ';' "\n" | grep SSH_AUTH_SOCK= | cut -d '=' -f 2)
	set -x SSH_AGENT_PID (echo $TMP_SSH | tr ';' "\n" | grep SSH_AGENT_PID= | cut -d '=' -f 2)
	ssh-add > /dev/null
	fish -c "\
	trap '/usr/bin/ssh-agent -k > /dev/null' EXIT
	eval $SHELL"
end

bind \cf 'lf; commandline -f repaint'

# fish config
function fish_greeting
	# PASS
	set pass_uncommited (pass git diff origin/master --numstat | wc -l)
	if [ $pass_uncommited -gt 0 ]
		set pass (set_color red) 'pass' (set_color normal) ": $pass_uncommited uncommited changes"
	else
		set pass (set_color green) 'pass: OK' (set_color normal)
	end
	
	# YADM
	set yadm_uncommited (yadm diff origin/master --numstat | wc -l)
	if [ $yadm_uncommited -gt 0 ]
		set yadm (set_color red) 'yadm' (set_color normal) ": $yadm_uncommited uncommited changes"
	else
		set yadm (set_color green) 'yadm: OK' (set_color normal)
	end
	
	# PACUTIL
	set pacutil (pacutil number)
	set pac_i (echo $pacutil | awk '{print $1}')
	set pac_r (echo $pacutil | awk '{print $2}')
	set pac_t (echo $pacutil | awk '{print $3}')
	[ $pac_t = 0 ] && set pac_color green || set pac_color red
	set pacutil (set_color $pac_color) 'pacutil:' (set_color green) $pac_i (set_color red) $pac_r (set_color normal) $pac_t
	
	if [ "$FISH_TOP" = no ]
		set -x FISH_TOP yes
		
		if [ -f .todo.md ] && [ -s .todo.md ]
			echo TODO:
			mdcat .todo.md
			echo
			echo
		end
		echo $pass
		echo
		echo $yadm
		echo
		echo $pacutil
		echo
		fortune -s | lolcat
		echo
	end
end

function fish_prompt
	set -l color_cwd
	set -l suffix
	set -l ssh
	set -l fail
	set -l vcs
	[ $status = 0 ]         || set fail '!'
	[ -n "$SSH_AGENT_PID" ] && set ssh  '#ssh'
	
	# vcs
	set __fish_git_prompt_showdirtystate true
	set vcs (fish_vcs_prompt)
	# if [ -z "$vcs" ] && string match "$HOME" "$PWD"
		
	# end
	[ -z "$vcs" ] || set vcs " $vcs"
	
	switch "$USER"
		case root
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
	echo -n -s $USER (set_color blue) $ssh (set_color normal) ' ' (set_color $color_cwd) (prompt_pwd) (set_color red) $fail $vcs (set_color normal) $suffix ' '
end

if [ -z "$FISH_TOP" ]
	set -x FISH_TOP no
end
