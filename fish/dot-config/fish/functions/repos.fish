# Function to download and synchornize all git repositories
#
function repos -d "This function will synchornize all git repositories"
    echo -ne "Synchronizing repositories \n"
    set _oldpath $PWD
    echo -ne "Pullinging dotfiles         1/7[███████..................................] \r"
    cd ~/.dotfiles/
    pull >/dev/null 2>&1
    echo -ne "Pullinging ansible          2/7[█████████████............................] \r"
    cd ~/ansible/
    pull >/dev/null 2>&1
    echo -ne "Pulling notes               3/7[████████████████████.....................] \r"
    cd ~/notes/
    pull >/dev/null 2>&1
    echo -ne "Pulling wallpaper           4/7[███████████████████████████..............] \r"
    cd ~/Pictures/wallpapers/
    pull >/dev/null 2>&1
    echo -ne "Pulling crashdot.com        5/7[██████████████████████████████████.......] \r"
    cd ~/web/crashdot.com/
    pull >/dev/null 2>&1
    echo -ne "Pulling sport-touring.eu    6/7[█████████████████████████████████████████] \r"
    cd ~/web/sport-touring.eu/
    pull >/dev/null 2>&1
    cd $_oldpath
    echo -ne "Done                        7/7[█████████████████████████████████████████] \r"
end
