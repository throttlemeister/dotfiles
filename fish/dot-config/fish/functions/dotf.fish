# Function for stow, to ingore .directory files and use 'dotfiles' special handling functionality
#
function dotf -d "Use stow with extra parameters"
    if command -sq stow
        stow -d ~/.dotfiles/ $argv --ignore=.directory --ignore=README.md --dotfiles
    else
        echo "Stow not installed. Please install before using."
    end
end
