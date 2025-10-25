function cp --wraps=advcp --wraps=cp -d 'Use advcp instead of cp when possible'
    __fish_dynamic_alias cp advcp cp % -p $argv
end
