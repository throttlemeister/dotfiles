function ff -d 'fastfetch shortcut'
    __fish_dynamic_alias ff "fastfetch -l ~/scripts/ascii/twart.txt -c $HOME/.config/fastfetch/throttlemeister.jsonc" neofetch % $argv
end
