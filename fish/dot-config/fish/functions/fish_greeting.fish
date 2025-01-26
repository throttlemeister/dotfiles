function fish_greeting
    # Giving us a nice welcome message
    if [ -z $container ]
        echo -e " Welcome to:"
        figlet (hostname -s)
        echo ""
        if test $USER = root
            inxi -Sc 12 && inxi -c 12
        else
            inxi -S && inxi
        end
        #cd

        # First make sure we have the latest version of code from git. If it's 
        # not there, we clone the repo.
        # Also, we only attempt this if there is a network connecttion!
        set __link (ip link ls | grep 'state UP')
        if [ -z $__link ]
            echo -e "\nNo network detected; skipping configuration checks...\n"
        else
            echo -e "\nChecking configurationse...\n"
            if test -d $HOME/.dotfiles/.git
                set _oldpath $PWD
                cd $HOME/.dotfiles
                git pull 1>/dev/null
                cd $_oldpath
            end

            # We do that for the Ansible directory too
            if test -d $HOME/ansible/.git
                set _oldpath $PWD
                cd $HOME/ansible
                git pull 1>/dev/null
                cd
                cd $_oldpath
            else
                set _oldpath $PWD
                cd $HOME
                git clone https://github.com/throttlemeister/ansible.git
                cd $_oldpath
            end
        end
        # GitHub way of authenticating changed, so we do not use this anymore.
        # Housekeeping.
        if test -f "$HOME/.secret"
            echo "Deleting obsolete GitHub credentials"
            rm $HOME/.secret
        end
    end
end
