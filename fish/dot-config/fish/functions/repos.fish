# Function to download and synchornize all git repositories
#
function repos -d "This function will synchornize all git repositories"
    set _oldpath $PWD
    echo -ne "Pulling dotfiles........ \r"
    cd ~/.dotfiles/
    pull >/dev/null 2>&1
    echo -ne "Pulling ansible......... \r"
    cd ~/ansible/
    pull >/dev/null 2>&1
    echo -ne "Pulling notes........... \r"
    cd ~/notes/
    pull >/dev/null 2>&1
    echo -ne "Pulling wallpaper....... \r"
    cd ~/Pictures/wallpapers/
    pull >/dev/null 2>&1
    echo -ne "Pulling crashdot.com.... \r"
    cd ~/web/crashdot.com/
    pull >/dev/null 2>&1
    echo -ne "Pulling sport-touring.eu \r"
    cd ~/web/sport-touring.eu/
    pull >/dev/null 2>&1
    cd $_oldpath
end
