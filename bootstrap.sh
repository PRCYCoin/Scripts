#!/bin/sh
clear
echo "Starting PRCY Bootstrap install script"
echo "Stopping prcycoind..."
prcycoin-cli stop
sleep 5
echo "Downloading BootStrap..."
wget -N https://bootstrap.prcycoin.com/prcy_bootstrap.zip
echo "Removing old blocks, chainstate, and database folders...."
rm -rf ~/.prcycoin/blocks ~/.prcycoin/chainstate ~/.prcycoin/database ~/.prcycoin/.lock ~/.prcycoin/prcycoind.pid
echo "Installing unzip..."
sudo apt-get install unzip -y
echo "Installing new blocks/chainstate folders..."
unzip -o prcy_bootstrap.zip -d ~/.prcycoin
echo "Bootstrap installed!"