function packages
    cat ~/ansible/files/pkg_opensuse.txt | while read -l pkg
        if type -q $pkg
            echo "Package $pkg already installed"
        else
            zypper in $pkg
        end
    end
end
