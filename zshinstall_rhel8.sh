#!/bin/bash/ -xe

# update and install zsh, wget, git
sudo yum update && sudo yum -y install zsh wget git util-linux-user

# change $SHELL to zsh
sudo chsh -s $(which zsh) $USER

# install config file and directory for user
sudo wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
su $USER

# add oh-my-zsh config to ~/.zshrc
sudo cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
sudo source ~/.zshrc
# create symlink and install for root
#sudo ln -s $HOME/.zshrc   /root/.zshrc
#sudo ln -s $HOME/.oh-my-zsh   /root/.oh-my-zsh
#su
#sudo chsh -s $(which zsh) $(whoami)

# pull Oh My Zsh theme powerlevel10k
sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# change ~/.zshrc theme to powerlevel10k
ZSH_THEME="powerlevel10k/powerlevel10k"
su $USER

