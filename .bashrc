# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

if command -v tmux>/dev/null; then
	[[ ! $TERM =~ screen ]] && [ -z $TMUX ] && { tmux attach || exec tmux new-session && exit; }
fi

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# force UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# include local executables
export PATH="/home/py/.local/bin:$PATH"

# Path to the bash it configuration
export BASH_IT="/home/py/.local/lib/bash_it"

# Lock and Load a custom theme file
# location /.bash_it/themes/
export BASH_IT_THEME='pure'

# (Advanced): Change this to the name of your remote repo if you
# cloned bash-it with a remote other than origin such as `bash-it`.
# export BASH_IT_REMOTE='bash-it'

# Your place for hosting Git repos. I use this for private repos.
export GIT_HOSTING='git@git.domain.com'

# Don't check mail when opening terminal.
unset MAILCHECK

# Change this to your console based IRC client of choice.
export IRC_CLIENT='irssi'

# Set this to the command you use for todo.txt-cli
export TODO="t"

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true

# Set Xterm/screen/Tmux title with only a short hostname.
# Uncomment this (or set SHORT_HOSTNAME to something else),
# Will otherwise fall back on $HOSTNAME.
#export SHORT_HOSTNAME=$(hostname -s)

# Set Xterm/screen/Tmux title with only a short username.
# Uncomment this (or set SHORT_USER to something else),
# Will otherwise fall back on $USER.
#export SHORT_USER=${USER:0:8}

# Set Xterm/screen/Tmux title with shortened command and directory.
# Uncomment this to set.
#export SHORT_TERM_LINE=true

# Set vcprompt executable path for scm advance info in prompt (demula theme)
# https://github.com/djl/vcprompt
#export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

# (Advanced): Uncomment this to make Bash-it reload itself automatically
# after enabling or disabling aliases, plugins, and completions.
# export BASH_IT_AUTOMATIC_RELOAD_AFTER_CONFIG_CHANGE=1

# Load Bash It
source "$BASH_IT"/bash_it.sh

# the one and only
export EDITOR=vim

# include hub completion
if [ -f /home/"$USER"/.local/lib/hub-linux-amd64-2.2.9/etc/hub.bash_completion.sh ]; then
    . /home/"$USER"/.local/lib/hub-linux-amd64-2.2.9/etc/hub.bash_completion.sh
fi

# include gopass completion
if command -v gopass >/dev/null; then
    source <(gopass completion bash)
fi

if command -v bat >/dev/null; then
    alias cat='bat'
fi

if command -v aws-vault >/dev/null; then
    alias avs='aws-vault exec --assume-role-ttl=1h staging --'
    alias als='aws-vault exec --assume-role-ttl=1h --mfa-token=$(ykman oath code --single BITPANDA-AWS) staging -- aws sts get-caller-identity'
    alias avp='aws-vault exec --assume-role-ttl=1h production --'
    alias alp='aws-vault exec --assume-role-ttl=1h --mfa-token=$(ykman oath code --single BITPANDA-AWS) production -- aws sts get-caller-identity'
    alias avbs='aws-vault exec --assume-role-ttl=1h bp-staging --'
    alias albs='aws-vault exec --assume-role-ttl=1h --mfa-token=$(ykman oath code --single BITPANDA-AWS) bp-staging -- aws sts get-caller-identity'
fi

if command -v todo.sh >/dev/null; then
    alias todo='todo.sh'
    # install bash completion and activate for alias
    source ~/.local/share/bash-completion/completions/todo
    complete -F _todo todo
fi

# include local init file
if [ -f /home/"$USER"/.bashrc.local ]; then
    . /home/"$USER"/.bashrc.local
fi
