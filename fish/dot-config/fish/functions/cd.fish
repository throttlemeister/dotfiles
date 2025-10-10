function cd -d 'Using zoxide as replacement for cd, if it exists'
    if type --quiet zoxide
        z $argv
    else
        command cd $argv
    end
end
