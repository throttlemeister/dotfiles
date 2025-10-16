# Function to download and synchornize all git repositories
#
function repos -d "This function will synchornize all git repositories"
    echo -ne "Synchronizing repositories \n"
    set _oldpath $PWD
    echo -ne "Pullinging dotfiles            [███████..................................] \r"
    cd ~/.dotfiles/
    pull >/dev/null 2>&1
    echo -ne "Pullinging ansible             [█████████████............................] \r"
    cd ~/ansible/
    pull >/dev/null 2>&1
    echo -ne "Pulling notes                  [████████████████████.....................] \r"
    cd ~/notes/
    pull >/dev/null 2>&1
    echo -ne "Pulling wallpaper              [███████████████████████████..............] \r"
    cd ~/Pictures/wallpapers/
    pull >/dev/null 2>&1
    echo -ne "Pulling crashdot.com           [██████████████████████████████████.......] \r"
    cd ~/web/crashdot.com/
    pull >/dev/null 2>&1
    echo -ne "Pulling sport-touring.eu       [█████████████████████████████████████████] \r"
    cd ~/web/sport-touring.eu/
    pull >/dev/null 2>&1
    cd $_oldpath
    echo -ne "Done                           [█████████████████████████████████████████] \r"
end
