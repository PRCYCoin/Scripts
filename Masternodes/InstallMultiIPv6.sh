#!/bin/sh
VERSION=$(curl -s4 https://raw.githubusercontent.com/PRCYCoin/PRCYCoin/master/version.txt)

clear
echo "Starting PRCY Masternode download and install..."
echo "Updating/Upgrading OS..."
sudo apt update && sudo apt upgrade -y
echo "Downloading latest build..."
wget -N https://github.com/PRCYCoin/PRCYCoin/releases/download/$VERSION/prcycoin-v$VERSION-x86_64-linux.zip
echo "Installing unzip..."
sudo apt-get install unzip -y
echo "Unzipping latest zip..."
sudo unzip -jo prcycoin-v$VERSION-x86_64-linux.zip -d /usr/local/bin
echo "Creating copies of prcycoind..."
sudo mv /usr/local/bin/prcycoind /usr/local/bin/prcycoind00
sudo cp /usr/local/bin/prcycoind00 /usr/local/bin/prcycoind01
sudo cp /usr/local/bin/prcycoind00 /usr/local/bin/prcycoind02
sudo cp /usr/local/bin/prcycoind00 /usr/local/bin/prcycoind03
sudo cp /usr/local/bin/prcycoind00 /usr/local/bin/prcycoind04
echo "Creating copies of prcycoin-cli..."
sudo mv /usr/local/bin/prcycoin-cli /usr/local/bin/prcycoin-cli00
sudo cp /usr/local/bin/prcycoin-cli00 /usr/local/bin/prcycoin-cli01
sudo cp /usr/local/bin/prcycoin-cli00 /usr/local/bin/prcycoin-cli02
sudo cp /usr/local/bin/prcycoin-cli00 /usr/local/bin/prcycoin-cli03
sudo cp /usr/local/bin/prcycoin-cli00 /usr/local/bin/prcycoin-cli04
sudo chmod +x /usr/local/bin/daps*
echo "Creating .prcycoin directories..."
mkdir ~/.prcycoin00
mkdir ~/.prcycoin01
mkdir ~/.prcycoin02
mkdir ~/.prcycoin03
mkdir ~/.prcycoin04
echo "Setting up and enabling fail2ban..."
sudo apt-get install fail2ban -y
sudo ufw allow ssh
sudo ufw allow 59682
sudo ufw allow 59683
sudo ufw enable
echo "Cleaning up..."
cd
rm -rf prcycoin-v$VERSION-x86_64-linux.zip
echo "PRCY Masternode installed successfully!"
