# Sigh. I guess it is not possible to set and keep set nvim as default
#
function vi
    if command -sq nvim
        nvim $argv
    else
        command vi $argv
    end
end
