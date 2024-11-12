function cd -d 'Using zoxide as replacement for cd, if it exists'
    if command -sq zoxide
        z $argv
    else
        command cd $argv
    end
end
