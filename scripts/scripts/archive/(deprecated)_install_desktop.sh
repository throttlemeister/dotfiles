#!/bin/bash

# User to setup profile and other files for
SETUP_USER=throttlemeister

# Check if Ansible is installed
if ! command -v ansible-playbook > /dev/null; then
  echo "Ansible is not installed. Installing Ansible now..."

  # Determine the package manager to use for installing Ansible
  if command -v dnf > /dev/null; then
    package_manager="dnf install -y"
  elif command -v apt-get > /dev/null; then
    package_manager="apt-get install -y"
  elif command -v zypper > /dev/null; then
  	package_manager="zypper install -y"
  else
    echo "Neither dnf nor apt-get nor zypper was found. Please install one of them or modify this script to match the distribution you are using"
    exit 1
  fi

  # Install Ansible and git
  $package_manager ansible
  $package_manager git
fi

# Setup profile
cd /home/$SETUP_USER
tar xvfz ansible/files/profile_local.tar.gz

# Clone fish configuration and ansible
cd /home/$SETUP_USER/.config
git clone git@github.com:throttlemeister/fish.git
cd /home/$SETUP_USER/
git clone git@github.com:throttlemeister/ansible.git

# Run the Ansible playbook to install standard packages
ansible-playbook files/install_local_packages.yml

#
# EOF
