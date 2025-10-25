function vi --wraps=nvim --wraps=vim --wraps=vi -d 'Use neovim or vim when possible'
    __fish_dynamic_alias vi nvim vim vi % $argv
end
