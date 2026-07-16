function askpass -d "installs and wraps askpass for 1P integration"
    if type -q /usr/local/bin/askpass
        command askpass $argv
    else
        set uhome $HOME
        echo "askpass not present... setting up"
        sudo stow -d $uhome/.dotfiles/local/ -t /usr/local/bin askpass
    end
end
