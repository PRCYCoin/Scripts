#!/bin/sh
VERSION=$(curl -s4 https://raw.githubusercontent.com/PRCYCoin/PRCYCoin/master/version.txt)

clear
echo "Starting PRCY Masternode update script"
echo "Stopping prcycoind..."
prcycoin-cli stop
echo "Downloading update..."
wget -N https://github.com/PRCYCoin/PRCYCoin/releases/download/$VERSION/prcycoin-v$VERSION-x86_64-linux.zip
echo "Installing unzip..."
sudo apt-get install unzip -y
echo "Extracting update..."
sudo unzip -jo prcycoin-v$VERSION-x86_64-linux.zip -d /usr/local/bin
echo "Set permissions on files..."
sudo chmod +x /usr/local/bin/daps*
echo "Running prcycoind..."
prcycoind -daemon
echo "Cleaning up..."
cd
rm -rf prcycoin-v$VERSION-x86_64-linux.zip
echo "Update completed!"
