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

# User to setup profile and other files for
SETUP_USER=throttlemeister
DOT_DIR=.dotfiles

# Check if git is installed and install if necessary
if ! command -v git >/dev/null; then
  echo "Git not installed. Installing now..."
  # install git
  sudo zypper --non-interactive in -y git
fi

# Clone dotfiles repo with submodule sand setup basic profile
cd /home/$SETUP_USER/
mkdir $DOT_DIR && cd $DOT_DIR
git clone git@github.com:throttlemeister/dotfiles.git .
cd /home/$SETUP_USER
tar xvfz $DOT_DIR/ansible/files/profile_local.tar.gz

# Check if Ansible is installed
if ! command -v ansible-playbook >/dev/null; then
  echo "Ansible is not installed. Installing Ansible now..."
  # Install Ansible
  sudo zypper --non-interactive in ansible
fi

# Run the Ansible playbook to install standard packages
ansible-playbook /home/$SETUP_USER/$DOT_DIR/ansible/files/install_pkg_opensuse.yml

# Setup user configuration using stow to setup the rest of the stuff
stow *
