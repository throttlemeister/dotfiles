function grep --wraps=rg --wraps=grep -d 'Use ripgrep instead of grep if possible'
    __fish_dynamic_alias grep rg grep % -n --color=auto $argv
end
