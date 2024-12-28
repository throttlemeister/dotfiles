function ff -d 'fastfetch shortcut'
    if type --quiet fastfetch
        if test -n "$ALACRITTY_WINDOW_ID"
            fastfetch -c examples/6.jsonc $argv
        else
            if test -n "$KITTY_WINDOW_ID"
                fastfetch -c examples/6.jsonc $argv
            else
                fastfetch -l ~/ansible/files/twgrey.png --logo-type iterm --logo-padding-top 2 --logo-width 45 -c examples/6.jsonc $argv
            end
        end
    else
        command neofetch $argv
    end
end

