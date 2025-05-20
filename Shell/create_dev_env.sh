#!bin/bash

# Install packages for development
sudo pacman -Syu vim nano git curl net-tools
echo "Packages installed at $(date)"

# Create folders
mkdir scripts python
echo "Folders created at $(date)"

# Add alias for 'git status'
echo "alias gs='git status'" >> ~/.bashrc
echo "Alias added at $(date)"

