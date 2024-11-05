# Function to download and synchornize all git repositories
#
function repos -d "This function will synchornize all git repositories"
    set _oldpath $PWD
    echo "Pull dotfiles repo.."
    cd ~/.dotfiles/
    pull
    echo "Pull ansible repo.."
    cd ~/ansible/
    pull
    echo "Pull wallpaper repo.."
    cd ~/Pictures/wallpaper/
    pull
    echo "Pull crashdot.com repo.."
    cd ~/web/crashdot.com/
    pull
    echo "Pull sport-touring.eu repo.."
    cd ~/web/sport-touring.eu/
    pull
    cd $_oldpath
end
