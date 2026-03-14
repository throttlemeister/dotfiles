function ssh -d "ssh using kitten when in kitty terminal"
    if test $argv = "thor.gvdtech.net" || test $argv = thor
        if test -n "$KITTY_WINDOW_ID"
            kitten ssh $argv -t fish
        else
            command ssh $argv -t fish
        end
    else
        if test - "$KITTY_WINDOW_ID"
            kitten ssh $argv
        else
            command ssh $argv
        end
    end
end
