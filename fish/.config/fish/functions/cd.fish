function cd -d 'Using zoxide as replacement for cd, if it exists'
    if command -sq zoxide
        z $argv
    else
        cd $argv
    end
end
