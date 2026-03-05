function zypper --wraps='sudo zypper'
    switch $argv[1]
        case up
            sudo zypper dup
        case rm
            sudo zypper rm --clean-deps $argv[2]
        case '*'
            sudo zypper $argv
    end
end
