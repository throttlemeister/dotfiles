function ssh -d "ssh using kitten when in kitty terminal"
    if test -n "$KITTY_WINDOW_ID"
        kitten ssh $argv
    else
        command ssh $argv
    end
end
