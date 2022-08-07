#!/bin/sh

PRCY='prcycoind'

clear
echo "Checking if prcycoind is running..."
if ps aux | grep -v grep | grep $PRCY> /dev/null
then
    echo "$PRCY is running, no further action required"
else
    echo "$PRCY is not running, starting it now"
	prcycoind -daemon
fi
