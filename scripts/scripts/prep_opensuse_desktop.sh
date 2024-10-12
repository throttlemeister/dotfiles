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
# 1.3 - Removed entry for doownloading Lazy-vim as it is now
#       integrated into the dotfules repo as a submodule.
#       (should we do this for our own ansible repo too?)
# 1.4 - Changed script and added ansible repo to dotfiles as
#       a new submodule so we can do a single pull
# 1.5 - Corrected a PATH
# 1.6 - Reverted back to seperate ansible and nvim repos ansible
#       dealing with submodules is a bit too much hassle for now.
# 1.7 - Clean up and some small adjustments.

# User to setup profile and other files for but first set some
# vaiables.
SETUP_USER=throttlemeister
DOT_DIR=.dotfiles
SETUP_USER_DIR=/home/$SETUP_USER

# Check if git is installed and install if necessary
if ! command -v git >/dev/null; then
  echo "Git not installed. Installing now..."
  # install git
  sudo zypper --non-interactive in -y git
fi

# Clone the ansible repo and extract basic profile
cd $SETUP_USER_DIR
git clone git@github.com:throttlemeister/ansible
tar xvfz ansible/files/profile_local.tar.gz

# Check if Ansible is installed
if ! command -v ansible-playbook >/dev/null; then
  echo "Ansible is not installed. Installing Ansible now..."
  # Install Ansible
  sudo zypper --non-interactive in ansible
fi

# Run the Ansible playbook to install standard packages
ansible-playbook $SETUP_USER_DIR/ansible/files/install_pkg_opensuse.yml

# Setup user configuration (dotfiles) using stow to setup the rest of the stuff
cd $SETUP_USER_DIR
git clone git@github.com:throttlemeister/dotfiles.git .dotfiles
cd $DOT_DIR
stow *

# Setup Neovim by cloning LazyVim
git clone https://github.com/LazyVim/starter $SETUP_USER_DIR/.config/nvim
