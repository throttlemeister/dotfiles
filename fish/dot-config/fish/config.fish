set -gx fish_prompt_pwd_dir_length 0
set -gx ANSIBLE_CONFIG $HOME/ansible/ansible.cfg
zoxide init fish | source
atuin init fish | source
bind up _atuin_bind_up
