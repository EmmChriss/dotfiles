# Environment

# Preferences
set -x EDITOR '/usr/bin/kak'
set -x VISUAL '/usr/bin/kak'
set -x PAGER  '/usr/bin/less'
set -x SHELL  '/usr/bin/fish'
set -x OPENER "$HOME/.bin/xdg-open"

# Defaults
set -x LESS       '-RS'
set -x BAT_THEME  'TwoDark'

# aliases
alias dots='git --work-tree=$HOME --git-dir=$HOME/.dotfiles.git'
alias tmux='tmux -2'
alias ssh='env TERM=xterm-color ssh'
alias cli-ref='curl -s "http://pastebin.com/raw/yGmGiDQX" | less -i'
alias ls='ls -h --group-directories-first --color=auto'

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
	if [ "$FISH_TOP" = no ]
		set -x FISH_TOP yes
		fortune -s | cowsay | lolcat
		echo
	end
end

function fish_prompt
	set -l color_cwd
	set -l suffix
	set -l ssh
	set -l fail
	[ $status = 0 ]         || set fail '!'
	[ -n "$SSH_AGENT_PID" ] && set ssh  '#ssh'
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
	echo -n -s $USER (set_color blue) $ssh (set_color normal) ' ' (set_color $color_cwd) (prompt_pwd) (set_color red) $fail (set_color normal) $suffix ' '
end

# login stuff
if status is-login
	set -p PATH "$HOME/.local/bin"
	set -p PATH "$HOME/.cargo/bin"
	set -p PATH $HOME/.gem/ruby/*/bin
	set -p PATH "$HOME/.bin"
	set -p PATH "$HOME/.bin/desktop"
	
	set -x LS_COLORS (sh -c 'eval $(dircolors $HOME/.config/DIR_COLORS); echo $LS_COLORS')
	
	[ (tty) = "/dev/tty1" ]; and exec startx > /dev/null
else if [ -z "$FISH_TOP" ]
	set -x FISH_TOP no
end
