function ff -d 'fastfetch shortcut'
    # __fish_dynamic_alias ff "fastfetch -l ~/scripts/ascii/twart.txt -c $HOME/.config/fastfetch/throttlemeister.jsonc" neofetch % $argv
    __fish_dynamic_alias ff fastfetch neofetch % $argv
end
