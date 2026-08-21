function last-download
    /usr/bin/ls -t ~/Downloads | read latest_modified
    echo ~/Downloads/$latest_modified
end
