#!/bin/bash
# install-zsh.sh
# A generic installer for zsh

# install zsh
sudo apt install zsh

# install oh my zsh
sh -c "$(curl -fsSL httpszsh://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# set zsh as default shell for Terminal
sudo chsh -s $(which zsh)
