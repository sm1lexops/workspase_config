# script for installing zsh cli & Oh-My_Zsh plugin
!#/bin/bash -xe

# update apt 
echo "==============update system================"
sudo apt update && sudo apt dist-upgrade -y
# install packages and dependencies for zsh
echo "====packages and dependencies installation====" 
echo "====during installation pls Press Y and hit Enter===="
sudo apt install -y build-essential curl file git zsh git-core fonts-powerline
ZSH_VERSION_CHECK="$(zsh --version)"
echo $ZSH_VERSION_CHECK
sleep 2
echo "====installing Oh-My-Zsh plugin===="
echo "====during installation pls Press Y and hit Enter===="
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
echo "====Zsh completly installed, next install Oh-My-Zsh plugin===="
sleep 0.5
echo "====download Oh-My-Zsh powerlevel10k theme===="
sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# change ~/.zshrc theme to powerlevel10k
echo "====changing ZSH_THEME===="
sed -i -e "/${ZSH_THEME}/powerlevel10k\/powerlevel10k/" ~/.zshrc
source ~/.zshrc
su $USER
echo "====Installation succesfully, check your Zsh===="



