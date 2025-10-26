function ls -d 'eza instead of ls'
    __fish_dynamic_alias ls "eza -g --header --group-directories-first --git --icons=auto" "exa -g --header --group-directories-first --git --icons=auto" ls % $argv
end

function ll
    __fish_dynamic_alias ls "eza -g --header --group-directories-first --git --icons=auto" "exa -g --header --group-directories-first --git --icons=auto" ls % -la $argv
end

function l
    __fish_dynamic_alias ls "eza --header --group-directories-first --git --icons=auto" "exa --header --group-directories-first --git --icons=auto" ls % $argv
end

function lt
    __fish_dynamic_alias ls "eza -laa -snew -g --header --group-directories-first --git --icons=auto" "exa -laa -snew -g --header --group-directories-first --git --icons=auto" "ls -ltr" % $argv
end

function lls
    __fish_dynamic_alias ls "eza -g --sort=size --header --group-directories-first --git --icons=auto" "exa -g --sort=size --header --group-directories-first --git --icons=auto" "ls -hS" % -la $argv
end
