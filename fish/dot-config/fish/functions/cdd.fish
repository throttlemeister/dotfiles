function cdd -d "cd with ls"
    cd $argv
    and begin
        ls -l
    end
end
