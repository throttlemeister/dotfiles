# Set global variable for common eza/exa flags
set -g _eflags "-g --header --group-directories-first --git --icons=auto"

function ls -d 'Using eza/exa instead of ls when installed'
    __fish_dynamic_alias ls "eza $_eflags" "exa $_eflags" ls % $argv
end

function ll
    __fish_dynamic_alias ls "eza $_eflags" "exa $_eflags" ls % -la $argv
end

function l
    __fish_dynamic_alias ls "eza $_eflags" "exa $_eflags" ls % $argv
end

function lt
    __fish_dynamic_alias ls "eza -aa -snew $_eflags" "exa -aa -snew $_eflags" "ls -tr" % -l $argv
end

function lls
    __fish_dynamic_alias ls "eza --sort=size $_eflags" "exa --sort=size $_eflags" "ls -hS" % -la $argv
end
