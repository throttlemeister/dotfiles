# Function for stow, to ingore .directory files and use 'dotfiles' special handling functionality
#
function dotf -d "Use stow with extra parameters"
    if command -sq stow
        stow -d ~/.dotfiles/ $argv --ignore=.directory --dotfiles
    end
end
