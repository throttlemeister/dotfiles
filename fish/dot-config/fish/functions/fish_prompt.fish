# This theme is based on Bira theme from oh-my-fish (https://github.com/oh-my-fish/theme-bira)
#
# This is a two line prompt theme. It shows user@host, path and git status on the left, and a command
# duraction on the right side.
#
# Createed by throttlemeister (https://www.github.com/theottlemeister)

function __user_host
    set fqdn (hostnamectl hostname)
    set -l content
    if [ (id -u) = 0 ]
        echo -n (set_color --bold yellow)\((set_color --bold red)$USER(set_color --bold yellow)@(set_color --bold red)$fqdn(set_color --bold yellow)\) (set color normal)
    else
        echo -n (set_color --bold blue)\((set_color --bold white)$USER(set_color --bold blue)@(set_color --bold white)$fqdn(set_color --bold blue)\) (set color normal)
    end
end

function __current_path
    if [ (id -u) = 0 ]
        echo -n (set_color --bold yellow)-[(set_color --bold white)(prompt_pwd)(set_color --bold yellow)](set_color normal)
    else
        echo -n (set_color --bold blue)-[(set_color --bold white)(prompt_pwd)(set_color --bold blue)](set_color normal)
    end
end

function __in_cont
    if [ -z $CONTAINER_ID ]
        set in_ct
    else
        set in_ct 
    end
    echo -n (set_color yellow) $in_ct (set_color normal)
end

function fish_prompt
    # Set some variables for git status
    set -g __fish_git_prompt_show_informative_status 1
    set -g __fish_git_prompt_showdirtystate 1
    set -g __fish_git_prompt_showuntrackedfiles 1
    set -g __fish_git_prompt_showupstream informative
    set -g __fish_git_prompt_showcolorhints 1
    set -g __fish_git_prompt_showstashstate 1
    set -g __fish_git_prompt_color_prefix yellow
    set -g __fish_git_prompt_color_suffix yellow
    set -g __fish_git_prompt_color yellow
    if [ (id -u) = 0 ]
        echo -n (set_color yellow)"╭─"(set_color normal)
    else
        echo -n (set_color blue)"╭─"(set_color normal)
    end
    __in_cont
    __user_host
    __current_path
    fish_git_prompt
    echo -e ''
    if [ (id -u) = 0 ]
        echo (set_color yellow)"╰─"(set_color red)"❯ "(set_color normal)
    else
        echo (set_color blue)"╰─"(set_color --bold green)"❯ "(set_color normal)
    end
end

function fish_right_prompt
    set -l st $status
    set -l __dur (math --scale=1 $CMD_DURATION/1000)

    if [ $st != 0 ]
        echo (set_color red) ↵ $st (set_color normal)
    end
    set_color -o brwhite
    echo "Time: $__dur s"
    set_color normal
end
