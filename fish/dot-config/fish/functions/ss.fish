function ss
    if test -z "$argv"
        command ss -tulnp
    else
        command ss $argv
    end
end
