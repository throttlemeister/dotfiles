function ls -d 'eza instead of ls'
    set -f _eflags "-g --header --group-directories-first --git --icons=auto"
    __fish_dynamic_alias ls "eza $_eflags" "exa $_eflags" ls % $argv
end

function ll
    set -f _eflags "-g --header --group-directories-first --git --icons=auto"
    __fish_dynamic_alias ls "eza $_eflags" "exa $_eflags" ls % -la $argv
end

function l
    set -f _eflags "-g --header --group-directories-first --git --icons=auto"
    __fish_dynamic_alias ls "eza $_eflags" "exa $_eflags" ls % $argv
end

function lt
    set -f _eflags "-g --header --group-directories-first --git --icons=auto"
    __fish_dynamic_alias ls "eza -laa -snew $_eflags" "exa -laa -snew $_eflags" "ls -ltr" % $argv
end

function lls
    set -f _eflags "-g --header --group-directories-first --git --icons=auto"
    __fish_dynamic_alias ls "eza --sort=size $_eflags" "exa --sort=size $_eflags" "ls -hS" % -la $argv
end
