function ping -d "Use gping or ping depending on availability"
    __fish_dynamic_alias ping gping ping % $argv
end
