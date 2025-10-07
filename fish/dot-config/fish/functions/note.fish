function note -d "Simple note taking with nvim"
    nvim ~/notes/README.md
    set _oldpath $PWD
    cd ~/notes/
    git add .
    git commit -a -m "Updating notes"
    git push
    cd $_oldpath
end
