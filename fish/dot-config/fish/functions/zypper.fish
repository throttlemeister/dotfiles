# Defined in - @ line 1
function zypper --wraps='sudo zypper'
    if test $argv[1] = up
        sudo zypper dup
    else
        if test $argv[1] = rm
            sudo zypper rm --clean-deps $argv[2]
        else
            sudo zypper $argv
        end
    end
end
