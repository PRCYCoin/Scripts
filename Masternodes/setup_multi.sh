#/bin/bash
VERSION=2.0.0.1

cd ~
echo "****************************************************************************"
echo "* Ubuntu 16.04 is the recommended opearting system for this install.       *"
echo "*               Adapted for PRCY by Canal Cripto Hold                      *"
echo "* This script will install and configure your PRCYCOIN masternodes.        *"
echo "****************************************************************************"
echo && echo && echo
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "!                                                 !"
echo "! Make sure you double check before hitting enter !"
echo "!                                                 !"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo && echo && echo

echo "Do you want to install all needed dependencies (no if you did it before)? [y/n]"
read DOSETUP

if [[ $DOSETUP =~ "y" ]] ; then
  sudo apt-get install -y nano htop git autoconf automake unzip
  sudo apt update && sudo apt upgrade -y
  

  cd /var
  sudo touch swap.img
  sudo chmod 600 swap.img
  sudo dd if=/dev/zero of=/var/swap.img bs=1024k count=5120
  sudo mkswap /var/swap.img
  sudo swapon /var/swap.img
  sudo free
  sudo echo "/var/swap.img none swap sw 0 0" >> /etc/fstab
  sudo sysctl vm.swappiness=50
  echo “vm.swappiness = 50” >> /etc/sysctl.conf 
  cd

  ## INSTALL
  wget https://github.com/PRCYCoin/PRCYCoin/releases/download/$VERSION/prcycoin-v$VERSION-x86_64-linux.zip
  sudo apt-get install unzip
  sudo unzip prcycoin-v$VERSION-x86_64-linux.zip -d /usr/local/bin
  chmod +x /usr/local/bin/prcycoind
  chmod +x /usr/local/bin/prcycoin-cli
  chmod +x /usr/local/bin/prcycoin-qt
  sudo chmod 755 daspcoin*
  sudo mv prcycoin* /usr/bin
  cd
  rm -rf prcycoin-v$VERSION-x86_64-linux.zip

  echo "Setting up and enabling fail2ban..."
  sudo apt-get install fail2ban -y
  sudo ufw allow ssh
  sudo ufw allow 59682
  sudo ufw allow 59683
  sudo ufw enable

  mkdir -p ~/bin
  echo 'export PATH=~/bin:$PATH' > ~/.bash_aliases
  source ~/.bashrc
fi

## Setup conf
mkdir -p ~/bin
IP=$(curl -s4 theiexplorers.com)
NAME="prcycoin"
CONF_FILE=prcycoin.conf

MNCOUNT=""
re='^[0-7]+$'
while ! [[ $MNCOUNT =~ $re ]] ; do
   echo ""
   echo "How many nodes do you want to create on this server?, followed by [ENTER]:"
   read MNCOUNT
done

for i in `seq 1 1 $MNCOUNT`; do
  echo ""
  echo "Enter alias for new node"
  read ALIAS  

  echo ""
  echo "Enter IPV6 for node $ALIAS (enter your ipv6 address here)"
  read IPADDRESS

  echo ""
  echo "Enter RPC Port (Any valid free port: i.E. 9001)"
  read RPCPORT

  echo ""
  echo "Enter masternode private key for node $ALIAS"
  read PRIVKEY

  ALIAS=${ALIAS,,}
  CONF_DIR=~/.${NAME}_$ALIAS

  # Create scripts
  echo '#!/bin/bash' > ~/bin/${NAME}d_$ALIAS.sh
  echo "${NAME}d -daemon -conf=$CONF_DIR/${NAME}.conf -datadir=$CONF_DIR "'$*' >> ~/bin/${NAME}d_$ALIAS.sh
  echo '#!/bin/bash' > ~/bin/${NAME}-cli_$ALIAS.sh
  echo "${NAME}-cli -conf=$CONF_DIR/${NAME}.conf -datadir=$CONF_DIR "'$*' >> ~/bin/${NAME}-cli_$ALIAS.sh
  chmod 755 ~/bin/${NAME}*.sh

  mkdir -p $CONF_DIR
  echo "rpcuser=user"`shuf -i 100000-10000000 -n 1` >> ${NAME}.conf_TEMP
  echo "rpcpassword=pass"`shuf -i 100000-10000000 -n 1` >> ${NAME}.conf_TEMP
  echo "rpcallowip=127.0.0.1" >> ${NAME}.conf_TEMP
  echo "rpcport=$RPCPORT" >> ${NAME}.conf_TEMP
  echo "listen=0" >> ${NAME}.conf_TEMP
  echo "server=1" >> ${NAME}.conf_TEMP
  echo "daemon=1" >> ${NAME}.conf_TEMP
  echo "logtimestamps=1" >> ${NAME}.conf_TEMP
  echo "maxconnections=256" >> ${NAME}.conf_TEMP
  echo "IPADDRESS=[$IPADDRESS]" >> ${NAME}.conf_TEMP
  echo "externalip=[$IPADDRESS]" >> ${NAME}.conf_TEMP
  echo "masternodeaddr=[$IPADDRESS]:59682" >> ${NAME}.conf_TEMP
  echo "bind=[$IPADDRESS]:59682" >> ${NAME}.conf_TEMP
  echo "masternode=1" >> ${NAME}.conf_TEMP
  echo "masternodeprivkey=$PRIVKEY" >> ${NAME}.conf_TEMP
  
  sudo ufw allow [$IPADDRESS]:59682/tcp

  mv ${NAME}.conf_TEMP $CONF_DIR/${NAME}.conf
  
  echo "Downloading bootstrap..."
  wget -o https://bootstrap.prcycoin.com/peers.dat
  cp peers.dat $CONF_DIR/peers.dat
  rm -rf prcy_bootstrap.zip
  wget https://bootstrap.prcycoin.com/prcy_bootstrap.zip
  echo "Removing old blocks, chainstate, and database folders...."
  rm -rf $CONF_DIR/blocks $CONF_DIR/chainstate $CONF_DIR/database
  echo "Installing new blocks folders..."
  sudo unzip -o prcy_bootstrap.zip -d $CONF_DIR
  rm -rf prcy_bootstrap.zip
  echo "Bootstrap installed!"

  sh ~/bin/${NAME}d_$ALIAS.sh
done
