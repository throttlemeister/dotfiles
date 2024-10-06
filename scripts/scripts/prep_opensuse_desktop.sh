#!/bin/bash

# This script is going to setup a new machine with the settings
# I like and some core utulities that I want to have installed
# on any of my systems.
#
# History:
# 1.0 - Modified from a generic, distro independant script
#       one that is specific for OpenSUSE.
# 1.1 - Updated so it can actually be run independant from
#       the presence of Ansible (we want to avoid a chicken
#       and egg problem)
# 1.2 - Make sure the script can be run from anywhere and
#       is not dependent on the location under ansible.

# User to setup profile and other files for
SETUP_USER=throttlemeister

# Check if git is installed and install if necessary
if ! command -v git >/dev/null; then
  echo "Git not installed. Installing now..."
  # install git
  sudo zypper --non-interactive in -y git
fi

# Clone ansible repo and setup basic profile
cd /home/$SETUP_USER/
git clone git@github.com:throttlemeister/ansible.git
cd /home/$SETUP_USER
tar xvfz ansible/files/profile_local.tar.gz

# Check if Ansible is installed
if ! command -v ansible-playbook >/dev/null; then
  echo "Ansible is not installed. Installing Ansible now..."
  # Install Ansible
  sudo zypper --non-interactive in ansible
fi

# Run the Ansible playbook to install standard packages
ansible-playbook /home/$SETUP_USER/ansible/files/install_pkg_opensuse.yml

# Clone dotfiles repo and use stow to setup the rest of the stuff
cd /home/$SETUP_USER/
mkdir .dotfiles
cd .dotfiles
git clone git@github.com:throttlemeister/dotfiles.git .
stow *

# Finally setup LazyVIM so we can have a nice VI experience.
git clone https://github.com/LazyVim/starter /home/$SETUP_USER/.config/nvim
