function figlet
    if type -q lolcat
        command figlet $argv | lolcat
    else
        command figlet $argv
    end
end
