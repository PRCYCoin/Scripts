#!/bin/sh
VERSION=$(curl -s4 https://raw.githubusercontent.com/PRCYCoin/PRCYCoin/master/version.txt)

clear
echo "Starting PRCY Masternode download and install script"
echo "Updating/Upgrading OS..."
sudo apt update && sudo apt upgrade -y
echo "Downloading latest build..."
wget -N https://github.com/PRCYCoin/PRCYCoin/releases/download/$VERSION/prcycoin-v$VERSION-x86_64-linux.zip
echo "Installing unzip..."
sudo apt-get install unzip -y
echo "Unzipping latest zip..."
sudo unzip -jo prcycoin-v$VERSION-x86_64-linux.zip -d /usr/local/bin
sudo chmod +x /usr/local/bin/prcycoin*
echo "Creating .prcycoin directory..."
mkdir ~/.prcycoin
cd ~/.prcycoin
echo "Editing prcycoin.conf..."
IP=$(ip a s eth0 | awk '/inet / {print$2}' | cut -d/ -f1)
echo rpcuser=user`shuf -i 100000-10000000 -n 1` >> prcycoin.conf
echo rpcpassword=pass`shuf -i 100000-10000000 -n 1` >> prcycoin.conf
echo rpcallowip=127.0.0.1 >> prcycoin.conf
echo server=1 >> prcycoin.conf
echo daemon=1 >> prcycoin.conf
echo listen=1 >> prcycoin.conf
echo staking=0 >> prcycoin.conf
echo logtimestamps=1 >> prcycoin.conf
echo masternode=1 >> prcycoin.conf
echo externalip=$IP:59682 >> prcycoin.conf
echo masternodeaddr=$IP:59682 >> prcycoin.conf
echo bind=$IP:59682 >> prcycoin.conf
echo masternodeprivkey= >> prcycoin.conf
nano prcycoin.conf >> prcycoin.conf
echo "Setting up and enabling fail2ban..."
sudo apt-get install fail2ban -y
sudo ufw allow ssh
sudo ufw allow 59682
sudo ufw allow 59683
sudo ufw enable

echo "Do you want to download and install the latest BootStrap? [y/n]"
read BOOTSTRAP

if [[ $BOOTSTRAP =~ "y" ]] ; then
  echo "Downloading BootStrap..."
  wget -N https://bootstrap.prcycoin.com/prcy_bootstrap.zip
  echo "Removing old blocks, chainstate, and database folders...."
  rm -rf ~/.prcycoin/blocks ~/.prcycoin/chainstate ~/.prcycoin/database ~/.prcycoin/.lock ~/.prcycoin/prcycoind.pid
  echo "Installing new blocks/chainstate folders..."
  unzip -o prcy_bootstrap.zip -d ~/.prcycoin
  echo "Bootstrap installed!"
fi

echo "Launching prcycoind..."
prcycoind -daemon
echo "Cleaning up..."
cd
rm -rf prcycoin-v$VERSION-x86_64-linux.zip
echo "PRCY Masternode installed successfully!"
