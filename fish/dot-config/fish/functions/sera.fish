function sera -d 'Installs or wraps sera script'
    if type -q /usr/local/bin/sera
        command sera $argv
    else
        set uhome $HOME
        echo "sera not present... setting up"
        sudo stow -d $uhome/.dotfiles -t /usr/local/bin sera
        if type -q bsdtar
            echo "bsdtar already present"
        else
            zypper in bsdtar
        end
    end
end
