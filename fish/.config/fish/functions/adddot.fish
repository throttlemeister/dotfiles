function adddot --wraps="stow"
    if [ -z $argv ]
        echo "No argument given; exiting"
    else
        set _oldpath $PWD
        cd ~/.dotfiles
        stow $argv
        cd $_oldpath
    end
end
