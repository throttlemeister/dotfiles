# Sigh. I guess it is not possible to set and keep set nvim as default
#
function vi --wraps="neovim to vi"
    if type --quiet nvim
        nvim $argv
    else
        command vi $argv
    end
end
