function note -d "Simple note taking with nvim"
    nvim ~/Documents/notes/README.md
    set _oldpath $PWD
    cd ~/Documents/notes/
    git add .
    git commit -a -m "Updating notes"
    git push
    cd $_oldpath
end
