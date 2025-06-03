function zypper --wraps='sudo zypper'
    switch $argv[1]
        case up
            sudo zypper dup
        case dup
            sudo zypper $argv
        case rm
            sudo zypper rm --clean-deps $argv[2]
        case ref
            sudo zypper $argv
        case '*'
            sudo zypper $argv
    end
end
