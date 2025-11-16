# This theme is based on Bira theme from oh-my-fish (https://github.com/oh-my-fish/theme-bira)
#
# This is a two line prompt theme. It shows user@host, path and git status on the left, and a command
# duration on the right side.
#
# Createed by throttlemeister (https://www.github.com/throttlemeister)
#
# Colors:
# Original: blue graphics, white for text, green with yellow brackets for git
#
# Catppuccin:
# graphics: normal
# USER: 81c8be
# hostname: 8caaee
# PATH: e5c890
# git: 

function __check_term
    if set -q KITTY_WINDOW_ID
        if [ (id -u) = 0 ]
            kitty @ set-colors background=#82181A
            return 0
        else
            kitty @ set-colors background=#303446
            return 0
        end
    end
    if set -q ALACRITTY_WINDOW_ID
        if [ (id -u) = 0 ]
            alacritty msg config "colors.primary.background='#82181A'"
            return 0
        else
            alacritty msg config "colors.primary.background='#303446'"
            return 0
        end
    end
end

function __user_host
    set fqdn (hostnamectl hostname)
    set -l content
    if [ (id -u) = 0 ]
        echo -n (set_color normal)\((set_color --bold red)$USER(set_color normal)@(set_color 8caaee)$fqdn(set_color normal)\)
    else
        echo -n (set_color normal)\((set_color 81c8be)$USER(set_color normal)@(set_color 8caaee)$fqdn(set_color normal)\)
    end
end

function __current_path
    if [ (id -u) = 0 ]
        echo -n (set_color normal)-[(set_color e5c890)(prompt_pwd)(set_color normal)]
    else
        echo -n (set_color normal) (set_color -b eebebe)(set_color --bold black)(prompt_pwd)(set_color -b normal)(set_color eebebe)(set_color normal)
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
    __check_term
    # Set some variables for git status
    set -g __fish_git_prompt_show_informative_status 1
    set -g __fish_git_prompt_showdirtystate 1
    set -g __fish_git_prompt_showuntrackedfiles 1
    set -g __fish_git_prompt_showupstream informative
    set -g __fish_git_prompt_showcolorhints 1
    set -g __fish_git_prompt_showstashstate 1
    set -g __fish_git_prompt_color_prefix normal
    set -g __fish_git_prompt_color_suffix normal
    set -g __fish_git_prompt_color yellow
    set -g __fish_git_prompt_char_stateseparator 
    echo -n "╭─"
    __in_cont
    __user_host
    __current_path
    fish_git_prompt
    echo -e ''
    if [ (id -u) = 0 ]
        echo "╰─"(set_color --bold red)"❯ "(set_color normal)
    else
        echo "╰─"(set_color --bold green)"❯ "(set_color normal)
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
