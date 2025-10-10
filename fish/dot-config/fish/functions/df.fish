function df -d "Using duf instead of df when we can"
    argparse h -- $argv
    or return
    if set -ql _flag_h
        set __param --only local
    end
    if type --quiet duf
        duf $__param
    else
        df $argv
    end
end
