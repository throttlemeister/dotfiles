function mv --wraps=advmv --wraps=mv -d 'Use advmv instead of mv when possible'
    __fish_dynamic_alias mv advmv mv % -p $argv
end
