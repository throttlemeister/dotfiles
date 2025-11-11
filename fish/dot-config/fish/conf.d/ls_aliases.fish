# Set global variable for common eza/exa flags
set -g _eflags "-g --header --group-directories-first --git --icons=auto"

function ls -d 'Using eza/exa instead of ls when installed'
    __fish_dynamic_alias ls "eza $_eflags" "exa $_eflags" ls % $argv
end

function ll
    __fish_dynamic_alias ll "eza $_eflags -a" "exa $_eflags -a" ls % -la $argv
end

function l
    __fish_dynamic_alias l "eza $_eflags" "exa $_eflags" ls % $argv
end

function lt
    __fish_dynamic_alias lt "eza -aa -snew $_eflags" "exa -aa -snew $_eflags" "ls -tr" % -l $argv
end

function lls
    __fish_dynamic_alias lls "eza --sort=size $_eflags -a" "exa --sort=size $_eflags -a" "ls -hS" % -la $argv
end
