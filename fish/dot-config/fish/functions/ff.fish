function ff -d 'fastfetch shortcut'
    __fish_dynamic_alias ff "fastfetch -l ~/ansible/files/twart.txt -c $HOME/.config/fastfetch/throttlemeister.jsonc" neofetch % $argv
end
