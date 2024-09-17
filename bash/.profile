# Make bash check its window size after a process completes
shopt -s checkwinsize

source ~/.bash_functions

host=`hostname -f`
								    
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad
# export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0

# Set terminal window title
export PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*} ${PWD}"; echo -ne "\007"'

# make tab-complete case insensitive
[[ $- = *i* ]] && bind TAB:menu-complete


 [[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

echo ""
cd
echo -e " Welcome to:"
figlet `hostname -s`
echo ""
inxi -S && inxi

export ANSIBLE_CONFIG=$HOME/ansible/ansible.cfg
