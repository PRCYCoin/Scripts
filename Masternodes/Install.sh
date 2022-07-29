
#!/bin/sh
VERSION=$(curl -s4 https://raw.githubusercontent.com/PRCYCoin/PRCYCoin/master/version.txt)
IP=$(hostname -i)
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
echo "Downloading BootStrap..."
wget -N https://bootstrap.prcycoin.com/prcy_bootstrap.zip
echo "Installing new blocks/chainstate folders..."
unzip -o prcy_bootstrap.zip -d ~/.prcycoin
echo "Bootstrap installed!"
echo "Bind port? "
read bindport
echo "RPC Port?"
read rpcport
echo "Editing prcycoin.conf..."
echo rpcuser=admin >> prcycoin.conf
echo rpcpassword=admin >> prcycoin.conf
echo rpcallowip=127.0.0.1 >> prcycoin.conf
echo server=1 >> prcycoin.conf
echo daemon=1 >> prcycoin.conf
echo listen=1 >> prcycoin.conf
echo staking=0 >> prcycoin.conf
echo logtimestamps=1 >> prcycoin.conf
echo masternode=1 >> prcycoin.conf
echo bind=127.0.0.1:$bindport >> prcycoin.conf
echo rpcport=$rpcport >> prcycoin.conf
echo externalip=$IP >> prcycoin.conf
echo masternodeprivkey= >> prcycoin.conf

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
echo "PRCY Masternode installed successfully!"
