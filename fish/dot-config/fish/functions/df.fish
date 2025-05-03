function df -d "Using duf instead of df when we can"
    if command -sq duf
        duf
    else
        df $argv
    end
end
