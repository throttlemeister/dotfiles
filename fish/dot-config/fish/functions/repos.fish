# Function to download and synchornize all git repositories
#
function repos -d "This function will synchornize all git repositories"
    set _oldpath $PWD
    echo "==========================================="
    echo "===========Pull dotfiles repo..============"
    echo "==========================================="
    cd ~/.dotfiles/
    pull
    echo "==========================================="
    echo "============Pull ansible repo..============"
    echo "==========================================="
    cd ~/ansible/
    pull
    echo "==========================================="
    echo "============Pull notes repo..============"
    echo "==========================================="
    cd ~/notes/
    pull
    echo "==========================================="
    echo "===========Pull wallpaper repo..==========="
    echo "==========================================="
    cd ~/Pictures/wallpaper/
    pull
    echo "==========================================="
    echo "=========Pull crashdot.com repo..=========="
    echo "==========================================="
    cd ~/web/crashdot.com/
    pull
    echo "==========================================="
    echo "=======Pull sport-touring.eu repo..========"
    echo "==========================================="
    cd ~/web/sport-touring.eu/
    pull
    cd $_oldpath
end
