#!/bin/sh
VERSION=$(curl -s4 https://raw.githubusercontent.com/PRCYCoin/PRCYCoin/master/version.txt)

clear
echo "Starting PRCY Staking node download and install script"
echo "Updating/Upgrading OS..."
sudo apt update && sudo apt upgrade -y
echo "Downloading latest build..."
wget -N https://github.com/PRCYCoin/PRCYCoin/releases/download/$VERSION/prcycoin-v$VERSION-x86_64-linux.zip
echo "Installing unzip..."
sudo apt-get install unzip -y
echo "Unzipping $VERSION-linux.zip..."
sudo unzip -jo prcycoin-v$VERSION-x86_64-linux.zip -d /usr/local/bin
sudo chmod +x /usr/local/bin/prcycoind
sudo chmod +x /usr/local/bin/prcycoin-cli
sudo chmod +x /usr/local/bin/prcycoin-qt
echo "Creating .prcycoin directory..."
mkdir ~/.prcycoin
cd ~/.prcycoin
echo "Editing prcycoin.conf..."
echo rpcuser= >> prcycoin.conf
echo rpcpassword= >> prcycoin.conf
echo rpcallowip=127.0.0.1 >> prcycoin.conf
echo server=1 >> prcycoin.conf
echo daemon=1 >> prcycoin.conf
echo staking=1 >> prcycoin.conf
echo logtimestamps=1 >> prcycoin.conf
echo maxconnections=256 >> prcycoin.conf
echo externalip= >> prcycoin.conf
vi prcycoin.conf >> prcycoin.conf
echo "Setting up and enabling fail2ban..."
sudo apt-get install fail2ban -y
sudo ufw allow ssh
sudo ufw allow 59682
sudo ufw allow 59683
sudo ufw enable
echo "Launching prcycoind..."
prcycoind -daemon
echo "Cleaning up..."
cd
rm -rf prcycoin-v$VERSION-x86_64-linux.zip
echo "Update completed!"
