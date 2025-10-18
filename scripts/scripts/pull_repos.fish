function pull_repos -d "Syncrhonize repositories with a dynamic progress bar"
    set repo dotfiles wallpapers ansible notes "crashdot.com" "sport-touring.eu"
    set repodir "~/.dotfiles" "~/Pictures/wallpapers/" "~/ansible/ ~/notes/" "~/web/crashdot.com/" "~/web/sport-touring.eu/"
    set _workdir $PWD
    set _total (count $repo)
    set _seq 1
    for i in (seq 1 $_total)
        print_progress $_total $_seq
        /usr/bin/cd $repodir[$_seq]
        git pull >/dev/null 2>&1
        echo -ne "\r"
        set _seq (math $_seq + 1)
    end
    cd $_workdir
    echo -ne Done
end
