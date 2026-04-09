function sudo
    if type -q sudo
        command sudo -A $argv
    else
        echo "sudo not installed"
    end
end
