# Function to download and synchornize all git repositories
#
function repos -d "This function will synchornize all git repositories"
    echo -ne "Synchronizing repositories \n"
    set _oldpath $PWD
    echo -ne "Pullinging dotfiles         1/6[███████..................................] \r"
    cd ~/.dotfiles/
    pull >/dev/null 2>&1
    echo -ne "Pullinging ansible          2/6[█████████████............................] \r"
    cd ~/ansible/
    pull >/dev/null 2>&1
    echo -ne "Pulling notes               3/6[████████████████████.....................] \r"
    cd ~/notes/
    pull >/dev/null 2>&1
    echo -ne "Pulling wallpaper           4/6[███████████████████████████..............] \r"
    cd ~/Pictures/wallpapers/
    pull >/dev/null 2>&1
    echo -ne "Pulling crashdot.com        5/6[██████████████████████████████████.......] \r"
    cd ~/web/crashdot.com/
    pull >/dev/null 2>&1
    echo -ne "Pulling sport-touring.eu    6/6[█████████████████████████████████████████] \r"
    cd ~/web/sport-touring.eu/
    pull >/dev/null 2>&1
    cd $_oldpath
    echo -ne "Done                        6/6[█████████████████████████████████████████] \n"
end
