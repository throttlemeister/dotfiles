#!/bin/bash

# This script is going to setup a new machine with the settings
# I like and some core utulities that I want to have installed
# on any of my systems.
#
# *** PLEASE RUN THIS SCRIPT AS ROOT, OR IT WILL FAIL ***
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
# 1.8 - Added section to check if the user is present on the systems
#       and if not, to create the user. And since we can br
#       deploying for another user as our own, we need to make sure
#       the files are all ownned by the correct user.

# User to setup profile and other files for but first set some
# vaiables.
SETUP_USER=throttlemeister
DOT_DIR=.dotfiles
SETUP_USER_DIR=/home/$SETUP_USER

# Check if $SETUP_USER exists, and if not, create the user first
if id "$SETUP_USER" &>/dev/null; then
  echo "Useer $SETUP_USER exists, continuing.."
else
  useradd -s /bin/fish -m $SETUP_USER
fi

# Check if git is installed and install if necessary
if ! command -v git >/dev/null; then
  echo "Git not installed. Installing now..."
  # install git
  zypper --non-interactive in -y git
fi

# Clone the ansible repo and extract basic profile
cd $SETUP_USER_DIR
git clone https://github.com/throttlemeister/ansible
tar xvfz ansible/files/profile_local.tar.gz

# Check if Ansible is installed
if ! command -v ansible-playbook >/dev/null; then
  echo "Ansible is not installed. Installing Ansible now..."
  # Install Ansible
  zypper --non-interactive in ansible
fi

# Run the Ansible playbook to install standard packages
ansible-playbook $SETUP_USER_DIR/ansible/files/install_pkg_opensuse.yml

# Setup user configuration (dotfiles) using stow to setup the rest of the stuff
cd $SETUP_USER_DIR
git clone https://github.com/throttlemeister/dotfiles.git .dotfiles
cd $DOT_DIR
stow * --ignore=.directory --ignore=README.md --dotfiles

# We need to clome a few github repositories that we need.
#
# Setup Neovim by cloning LazyVim (yeeh)
cd $SETUP_USER_DIR
git clone https://github.com/LazyVim/starter $SETUP_USER_DIR/.config/nvim
# Let's make sure we can also do webdevelopment
mkdir web
git clone https://github.com/throttlemeister/crashdot.com.git web/crashdot.com
git clone https://github.com/throttlemeister/sport-touring.eu.git web/sport-touring.eu

# Ensure all files in $SETUP_USER_DIR are owned by the user
chown -R $SETUP_USER:users $SETUP_USER_DIR

# We're done. Do check our handywork :)
echo "Tasks complete..."
