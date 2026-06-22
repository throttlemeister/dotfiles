function svi --wraps=nvim --wraps=vim --wraps=vi -d 'Use neovim or vim when possible'
    if type -q sudo
        sudo -e $argv
    else
        echo "sudo not installed"
    end
end
