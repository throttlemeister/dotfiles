function cp
    if type --quiet advcp
        advcp -g $argv
    else
        command cp $argv
    end
end
