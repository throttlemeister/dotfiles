function fish_greeting
    # Giving us a nice welcome message
    if [ -z $container ]
        echo -e " Welcome to:"
        figlet (hostname -s)
        echo ""
        if test $USER = root
            kitty @ set-colors background=#82181A
            #inxi -Sc 12 && inxi -c 12
            figlet "root shell"
        else
            kitty @ set-colors background=#303446
            inxi -S && inxi
        end
        #cd

        # First make sure we have the latest version of code from git. If it's 
        # not there, we clone the repo.
        # Also, we only attempt this if there is a network connecttion!
        set __link (ip link ls | grep 'state UP')
        if [ -z $__link ] 2>/dev/null
            echo -e "\nNo network detected; skipping configuration checks...\n"
        else
            if test -z (find ~/.gitcheck -mmin -240)
                echo -ne "\nSynchronizing configuration \n"
                sleep 0.5
                if test -d $HOME/.dotfiles/.git
                    set _oldpath $PWD
                    cd $HOME/.dotfiles
                    echo -ne "Syncing dotfiles            1/2[██████████████...........................] \r"
                    git pull >/dev/null 2>&1
                    cd $_oldpath
                end
                #            # We do that for the Ansible directory too
                #            if test -d $HOME/ansible/.git
                #                set _oldpath $PWD
                #                cd $HOME/ansible
                #                echo "Updating ansible"
                #                git pull 1>/dev/null
                #                cd
                #                cd $_oldpath
                #            else
                #                set _oldpath $PWD
                #                cd $HOME
                #                git clone https://github.com/throttlemeister/ansible.git
                #                cd $_oldpath
                #            end
                # And for our notes directory
                if test -d $HOME/notes
                    set _oldpath $PWD
                    cd $HOME/notes
                    echo -ne "Syncing notes               2/2[████████████████████████████.............] \r"
                    git pull >/dev/null 2>&1
                    cd
                    cd $_oldpath
                else
                    set _oldpath $PWD
                    cd $HOME
                    echo "Notes not found. Cloning from GitHub"
                    github notes
                    cd $_oldpath
                end
                echo -ne "Done                        2/2[█████████████████████████████████████████] \n"
                echo -ne "\n"
                touch ~/.gitcheck
            else
                echo -ne "No refresh required"
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
