function mv
    if type --quiet advmv
        advmv -g $argv
    else
        command mv $argv
    end
end
